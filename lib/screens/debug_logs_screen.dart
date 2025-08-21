import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../services/release_logger.dart';
import '../config/font_constants.dart';

/// Debug screen for viewing and sharing logs in release builds
class DebugLogsScreen extends StatefulWidget {
  const DebugLogsScreen({super.key});

  @override
  State<DebugLogsScreen> createState() => _DebugLogsScreenState();
}

class _DebugLogsScreenState extends State<DebugLogsScreen> {
  List<String> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => isLoading = true);
    try {
      final loadedLogs = await ReleaseLogger.getLogs();
      setState(() {
        logs = loadedLogs.reversed.toList(); // Show newest first
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        logs = ['Error loading logs: $e'];
        isLoading = false;
      });
    }
  }

  Future<void> _shareLogs() async {
    try {
      final logsString = await ReleaseLogger.getLogsAsString();
      await Share.share(logsString, subject: 'YouthSpot App Logs');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share logs: $e')),
      );
    }
  }

  Future<void> _clearLogs() async {
    try {
      await ReleaseLogger.clearLogs();
      setState(() => logs.clear());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logs cleared successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to clear logs: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Logs'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: logs.isNotEmpty ? _shareLogs : null,
            tooltip: 'Share Logs',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: logs.isNotEmpty ? _clearLogs : null,
            tooltip: 'Clear Logs',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogs,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Text(
              'Total logs: ${logs.length}',
              style: AppTextStyles.primarySemiBold,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : logs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.info_outline, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              'No logs available',
                              style: AppTextStyles.primaryBold.copyWith(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try triggering some actions like password reset',
                              style: AppTextStyles.primaryRegular.copyWith(
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          final isError = log.contains('ERROR:');
                          final isInfo = log.contains('INFO:');
                          
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            elevation: 1,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.left(
                                  width: 4,
                                  color: isError
                                      ? Colors.red
                                      : isInfo
                                          ? Colors.blue
                                          : Colors.grey,
                                ),
                              ),
                              child: Text(
                                log,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: isError ? Colors.red[800] : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}