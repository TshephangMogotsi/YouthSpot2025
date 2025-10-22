import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../config/theme_manager.dart';
import '../services/services_locator.dart';

/// A reusable widget for displaying empty states when data is unavailable
/// Shows a friendly, concise message to users
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final bool showRetryButton;

  const EmptyStateWidget({
    super.key,
    this.message = 'Content will load when connected',
    this.icon = Icons.cloud_off_outlined,
    this.onRetry,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, _) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 64,
                  color: theme == ThemeMode.dark
                      ? Colors.grey[600]
                      : Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme == ThemeMode.dark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
                if (showRetryButton && onRetry != null) ...[
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Retry'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kSSIorange,
                      side: const BorderSide(color: kSSIorange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
