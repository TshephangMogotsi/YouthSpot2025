import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../db/app_db.dart';
import '../../../db/models/journal_model.dart';

class CustomJournalWidget extends StatefulWidget {
  final JournalEntry? journalEntry;
  final bool readOnly;

  const CustomJournalWidget(
      {super.key, this.journalEntry, this.readOnly = false});

  @override
  State<CustomJournalWidget> createState() => _CustomJournalWidgetState();
}

class _CustomJournalWidgetState extends State<CustomJournalWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  late QuillController _contentController;
  late bool isImportant;
  late int number;

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
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            readOnly: widget.readOnly,
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
          if (!widget.readOnly)
            QuillSimpleToolbar(
              controller: _contentController,
            ),
          const Divider(),
          Expanded(
            child: QuillEditor(
              controller: _contentController,
              focusNode: _editorFocusNode,
              scrollController: _editorScrollController,
              config: QuillEditorConfig(
                placeholder: 'Start writing your notes...',
                padding: const EdgeInsets.all(16),
                readOnly: widget.readOnly,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.readOnly
          ? null
          : FloatingActionButton(
              onPressed: saveNote,
              child: const Icon(Icons.save),
            ),
    );
  }

  Future<void> saveNote() async {
    final isValid = _formKey.currentState?.validate() ?? true;

    if (isValid) {
      final isUpdating = widget.journalEntry != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> updateNote() async {
    final json = jsonEncode(_contentController.document.toDelta().toJson());
    final note = widget.journalEntry!.copy(
      isImportant: isImportant,
      number: number,
      title: _titleController.text,
      description: json,
    );

    await SSIDatabase.instance.updateJournalEntry(note);
  }

  Future<void> addNote() async {
    final json = jsonEncode(_contentController.document.toDelta().toJson());
    final journalEntry = JournalEntry(
      title: _titleController.text,
      isImportant: isImportant,
      number: number,
      description: json,
      createdTime: DateTime.now(),
    );

    await SSIDatabase.instance.createJounalEntry(journalEntry);
  }

  @override
  void dispose() {
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }
}
