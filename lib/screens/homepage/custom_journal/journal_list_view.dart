import 'package:flutter/material.dart';

import '../../../db/app_db.dart';
import '../../../db/models/journal_model.dart';
import 'custom_journal_widget.dart';

class JournalListView extends StatefulWidget {
  const JournalListView({super.key});

  @override
  State<JournalListView> createState() => _JournalListViewState();
}

class _JournalListViewState extends State<JournalListView> {
  late List<JournalEntry> journals;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshJournals();
  }

  Future refreshJournals() async {
    setState(() {
      isLoading = true;
    });

    journals = await SSIDatabase.instance.readAllJournalEntries();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CustomJournalWidget(),
                ),
              );
              refreshJournals();
            },
          ),
        ],
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : journals.isEmpty
              ? const Center(child: Text('No Journals'))
              : ListView.builder(
                  itemCount: journals.length,
                  itemBuilder: (context, index) {
                    final journalEntry = journals[index];
                    return ListTile(
                      title: Text(journalEntry.title),
                      subtitle: Text(journalEntry.description),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CustomJournalWidget(
                              journalEntry: journalEntry,
                            ),
                          ),
                        );
                        refreshJournals();
                      },
                    );
                  },
                ),
    );
  }
}
