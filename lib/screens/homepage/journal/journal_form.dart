import 'package:flutter/material.dart';

import '../../../../config/theme_manager.dart';
import '../../../../services/services_locator.dart';

class JournalFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final Widget widget;

  const JournalFormWidget({
    super.key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLines: 1,
                          initialValue: title,
                          style: TextStyle(
                            color: theme == ThemeMode.dark
                                ? Colors.white
                                : const Color(0xFF1C1C24),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            hintStyle: TextStyle(
                              color: theme == ThemeMode.dark
                                  ? Colors.white
                                  : const Color(0xFF1C1C24),
                            ),
                          ),
                          // validator: (title) => title != null && title.isEmpty
                          //     ? 'The title cannot be empty'
                          //     : null,
                          onChanged: onChangedTitle,
                        ),
                      ),
                      // widget
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 5,
                    initialValue: description,
                    style: TextStyle(
                        color: theme == ThemeMode.dark
                            ? Colors.white
                            : const Color(0xFF1C1C24),
                        fontSize: 18),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'What is on your mind...',
                      hintStyle: TextStyle(
                        color: theme == ThemeMode.dark
                            ? Colors.white
                            : const Color(0xFF1C1C24),
                      ),
                    ),
                    // validator: (title) => title != null && title.isEmpty
                    //     ? 'The description cannot be empty'
                    //     : null,
                    onChanged: onChangedDescription,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        });
  }
}
