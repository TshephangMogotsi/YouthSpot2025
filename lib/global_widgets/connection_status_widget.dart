import 'package:flutter/material.dart';
import 'package:youthspot/config/supabase_manager.dart';
import 'package:youthspot/config/constants.dart';

class ConnectionStatusWidget extends StatefulWidget {
  final Widget child;
  
  const ConnectionStatusWidget({super.key, required this.child});

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    // If Supabase is ready, show the normal app
    if (SupabaseManager.isReady) {
      return widget.child;
    }

    // If there's an error, show connection error screen
    if (SupabaseManager.hasError) {
      return MaterialApp(
        title: 'YouthSpot',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: backgroundColorLight,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off_rounded,
                    size: 80,
                    color: Colors.grey[600],
                  ),
                  const Height20(),
                  Text(
                    'Connection Error',
                    style: headingStyle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Height10(),
                  Text(
                    SupabaseManager.lastError ?? 'Unable to connect to server',
                    style: subTitleStyle.copyWith(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Height20(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                          size: 24,
                        ),
                        const Height10(),
                        Text(
                          'Troubleshooting Tips:',
                          style: titleStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        const Height10(),
                        ...[
                          '• Check your internet connection',
                          '• Try switching between WiFi and mobile data',
                          '• Restart the app if the problem persists',
                          '• Contact support if the issue continues',
                        ].map((tip) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              tip,
                              style: subTitleStyle.copyWith(
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  const Height20(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isRetrying ? null : _retryConnection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSSIorange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isRetrying
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                const Width10(),
                                Text(
                                  'Retrying...',
                                  style: titleStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Try Again',
                              style: titleStyle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Show loading screen while initializing
    return MaterialApp(
      title: 'YouthSpot',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColorLight,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kSSIorange),
              ),
              Height20(),
              Text(
                'Connecting to YouthSpot...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _retryConnection() async {
    setState(() {
      _isRetrying = true;
    });

    final success = await SupabaseManager.retryInitialization();
    
    setState(() {
      _isRetrying = false;
    });

    if (success) {
      // The ConnectionStatusWidget will automatically rebuild and show the app
      setState(() {});
    }
  }
}