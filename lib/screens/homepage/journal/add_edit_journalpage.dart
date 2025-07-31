import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../services/services_locator.dart';
import '../../../db/app_db.dart';
import '../../../db/models/journal_model.dart';
import '../../../global_widgets/primary_padding.dart';
import '../../../global_widgets/primary_scaffold.dart';

import 'delete_dialog.dart';

class AddEditJournalPage extends StatefulWidget {
  final JournalEntry? journalEntry;

  const AddEditJournalPage({
    super.key,
    this.journalEntry,
  });

  @override
  State<AddEditJournalPage> createState() => _AddEditJournalPageState();
}

class _AddEditJournalPageState extends State<AddEditJournalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late bool isImportant;
  late int number;

  @override
  void initState() {
    super.initState();
    isImportant = widget.journalEntry?.isImportant ?? false;
    number = widget.journalEntry?.number ?? 0;
    _titleController.text = widget.journalEntry?.title ?? '';
    _contentController.text = widget.journalEntry?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (_titleController.text.isNotEmpty ||
            _contentController.text.isNotEmpty) {
          addOrUpdateNote();
        }
      },
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return PrimaryScaffold(
            child: SafeArea(
              child: Column(
                children: [
                  PrimaryPadding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Journal',
                          style: headingStyle,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: theme == ThemeMode.dark
                                ? Colors.white
                                : const Color(0xFF1C1C24),
                          ),
                          onPressed: deleteJournalEntry,
                        ),
                      ],
                    ),
                  ),
                  const Height10(),
                  Expanded(
                    child: Container(
                      color: theme == ThemeMode.dark ? darkmodeFore : Colors.white,
                      child: PrimaryPadding(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  hintText: 'Title',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              TextField(
                                controller: _contentController,
                                maxLines: null, // Allows for unlimited lines
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  hintText: 'What is on your mind...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState?.validate() ?? true;

    if (isValid) {
      final isUpdating = widget.journalEntry != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      // Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.journalEntry!.copy(
      isImportant: isImportant,
      number: number,
      title: _titleController.text,
      description: _contentController.text,
    );

    await SSIDatabase.instance.updateJournalEntry(note);
  }

  Future addNote() async {
    final journalEntry = JournalEntry(
      title: _titleController.text,
      isImportant: isImportant,
      number: number,
      description: _contentController.text,
      createdTime: DateTime.now(),
    );

    await SSIDatabase.instance.createJounalEntry(journalEntry);
  }

  Future<void> deleteJournalEntry() async {
    if (widget.journalEntry == null) {
      Navigator.of(context).pop();
    } else {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => const DeleteDialog(),
      );

      if (shouldDelete ?? false) {
        await SSIDatabase.instance.deleteJournalEntry(
          widget.journalEntry!.id!,
        );
        Navigator.of(context).pop();
      }
    }
  }
}
