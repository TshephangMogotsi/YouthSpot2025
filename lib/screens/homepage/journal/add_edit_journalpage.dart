import 'dart:convert';
import 'dart:io'; // Importing dart:io to use Platform

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../services/services_locator.dart';
import '../../../db/app_db.dart';
import '../../../db/models/journal_model.dart';
import '../../../global_widgets/primary_padding.dart';
import '../../../global_widgets/primary_scaffold.dart';
import '../../../providers/pointsProviders/journal_points_provider.dart';
import 'delete_dialog.dart';

class AddEditJournalPage extends StatefulWidget {
  final JournalEntry? journalEntry;

  const AddEditJournalPage({super.key, this.journalEntry});

  @override
  State<AddEditJournalPage> createState() => _AddEditJournalPageState();
}

class _AddEditJournalPageState extends State<AddEditJournalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  late QuillController _contentController;
  late bool isImportant;
  late int number;

  // Declare the focus node here
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isImportant = widget.journalEntry?.isImportant ?? false;
    number = widget.journalEntry?.number ?? 0;
    _titleController.text = widget.journalEntry?.title ?? '';

    final description = widget.journalEntry?.description ?? '';
    if (description.isNotEmpty) {
      try {
        final doc = Document.fromJson(jsonDecode(description));
        _contentController = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _contentController = QuillController.basic();
        _contentController.document.insert(0, description);
      }
    } else {
      _contentController = QuillController.basic();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (_titleController.text.isNotEmpty ||
            !_contentController.document.isEmpty()) {
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
                        Text('Journal', style: headingStyle),
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
                      color: theme == ThemeMode.dark
                          ? darkmodeFore
                          : Colors.white,
                      child: PrimaryPadding(
                        child: Column(
                          children: [
                            // Move the Scrollable area inside a Column
                            Flexible(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Your TextField and Toolbar widgets go here
                                    TextField(
                                      controller: _titleController,
                                      decoration: const InputDecoration(
                                        hintText: 'Title',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    QuillSimpleToolbar(
                                      controller: _contentController,
                                      config: QuillSimpleToolbarConfig(
                                        buttonOptions:
                                            QuillSimpleToolbarButtonOptions(
                                              base: QuillToolbarBaseButtonOptions(
                                                afterButtonPressed: () {
                                                  // Use Platform.is here to check for platform
                                                  if (Platform.isWindows ||
                                                      Platform.isLinux ||
                                                      Platform.isMacOS) {
                                                    _editorFocusNode
                                                        .requestFocus();
                                                  }
                                                },
                                              ),
                                            ),
                                      ),
                                    ),
                                    const Divider(),
                                    QuillEditor(
                                      controller: _contentController,
                                      focusNode: _editorFocusNode,
                                      scrollController: _editorScrollController,
                                      config: QuillEditorConfig(
                                        placeholder:
                                            'Start writing your notes...',
                                        padding: const EdgeInsets.all(16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    final json = jsonEncode(_contentController.document.toDelta().toJson());
    final note = widget.journalEntry!.copy(
      isImportant: isImportant,
      number: number,
      title: _titleController.text,
      description: json,
    );

    await SSIDatabase.instance.updateJournalEntry(note);
  }

  Future addNote() async {
    final json = jsonEncode(_contentController.document.toDelta().toJson());
    final journalEntry = JournalEntry(
      title: _titleController.text,
      isImportant: isImportant,
      number: number,
      description: json,
      createdTime: DateTime.now(),
    );

    await SSIDatabase.instance.createJounalEntry(journalEntry);

    // Award points for adding a new journal entry
    Provider.of<JournalPointsProvider>(
      context,
      listen: false,
    ).addJournalEntryPoints();
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
        await SSIDatabase.instance.deleteJournalEntry(widget.journalEntry!.id!);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }
}
