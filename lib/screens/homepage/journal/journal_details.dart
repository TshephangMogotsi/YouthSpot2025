import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';

import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../services/services_locator.dart';
import '../../../db/app_db.dart';
import '../../../db/models/journal_model.dart';
import 'add_edit_journalpage.dart';
import 'delete_dialog.dart';

class JournalDetailPage extends StatefulWidget {
  final int journalID;

  const JournalDetailPage({
    super.key,
    required this.journalID,
  });

  @override
  State<JournalDetailPage> createState() => _JournalDetailPageState();
}

class _JournalDetailPageState extends State<JournalDetailPage> {
  late JournalEntry journalEntry;
  bool isLoading = false;
  late QuillController _controller;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    journalEntry =
        await SSIDatabase.instance.readJournalEntry(widget.journalID);

    try {
      final doc = Document.fromJson(jsonDecode(journalEntry.description));
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      _controller = QuillController.basic();
      _controller.document.insert(0, journalEntry.description);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return Scaffold(
            backgroundColor: theme == ThemeMode.dark
                ? const Color(0xFF1C1C24)
                : backgroundColorLight,
            appBar: AppBar(
              backgroundColor: theme == ThemeMode.dark
                  ? const Color(0xFF1C1C24)
                  : backgroundColorLight,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: theme == ThemeMode.dark
                      ? Colors.white
                      : const Color(0xFF1C1C24),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: theme == ThemeMode.dark
                          ? Colors.white
                          : const Color(0xFF1C1C24),
                    ),
                    onPressed: () async {
                      if (isLoading) return;

                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddEditJournalPage(journalEntry: journalEntry),
                      ));

                      refreshNote();
                    }),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: theme == ThemeMode.dark
                        ? Colors.white
                        : const Color(0xFF1C1C24),
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => const DeleteDialog(),
                    );
                    await SSIDatabase.instance.deleteJournalEntry(
                      widget.journalID,
                    );

                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        Text(
                          journalEntry.title,
                          style: TextStyle(
                            color: theme == ThemeMode.dark
                                ? Colors.white
                                : const Color(0xFF1C1C24),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat.yMMMd().format(journalEntry.createdTime),
                          style: const TextStyle(color: Colors.white38),
                        ),
                        const SizedBox(height: 8),
                        QuillEditor.basic(
                          configurations: QuillEditorConfigurations(
                            controller: _controller,
                            readOnly: true,
                            sharedConfigurations: const QuillSharedConfigurations(
                              locale: Locale('en'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          );
        });
  }

  // Widget editButton() => IconButton(
  //     icon: const Icon(Icons.edit_outlined,),
  //     onPressed: () async {
  //       if (isLoading) return;

  //       await Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) => AddEditJournalPage(journalEntry: journalEntry),
  //       ));

  //       refreshNote();
  //     });

  // Widget deleteButton() => IconButton(
  //       icon: const Icon(Icons.delete),
  //       onPressed: () async {
  //         await SSIDatabase.instance.deleteJournalEntry(widget.journalID);

  //         Navigator.of(context).pop();
  //       },
  //     );
}
