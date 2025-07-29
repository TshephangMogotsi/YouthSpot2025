import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../services/services_locator.dart';
import '../../../db/models/journal_model.dart';

class JournalCard extends StatelessWidget {
  const JournalCard({
    super.key,
    required this.journalEntry,
    required this.index,
  });

  final JournalEntry journalEntry;
  final int index;

  @override
  Widget build(BuildContext context) {
    final minHeight = getMinHeight(index);
    final themeManager = getIt<ThemeManager>();


    return ValueListenableBuilder<Object>(
      valueListenable: themeManager.themeMode,
      builder: (context,theme, snapshot) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(innerBorderRadius),
          ),
          color: theme == ThemeMode.dark ? darkmodeFore : Colors.white,  // Set card background color to white
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Removed the date text
                Text(
                  journalEntry.title,
                  style:  TextStyle(
                    color:  theme == ThemeMode.dark ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Displaying a portion of the journal entry text
                Text(
                  journalEntry.description.length > 100
                      ? "${journalEntry.description.substring(0, 100)}..."
                      : journalEntry.description,
                  style:  TextStyle(
                    color: theme == ThemeMode.dark ? Colors.white : Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
