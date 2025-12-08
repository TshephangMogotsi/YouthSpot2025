import 'package:youthspot/db/models/journal_model.dart' show JournalEntry;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../db/app_db.dart';
import '../../../../services/services_locator.dart';
import '../../../global_widgets/primary_padding.dart';
import 'add_edit_journalpage.dart';
import 'journal_card.dart';

class Journal extends StatefulWidget {
  const Journal({super.key});

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  late List<JournalEntry> journals;
  List<JournalEntry> filteredJournals = [];
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    refreshJournals();
    _searchController.addListener(_filterJournals);
  }

  Future refreshJournals() async {
    setState(() {
      isLoading = true;
    });

    journals = await SSIDatabase.instance.readAllJournalEntries();
    filteredJournals = journals;

    setState(() {
      isLoading = false;
    });
  }

  void _filterJournals() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredJournals = journals;
      } else {
        filteredJournals = journals.where((journal) {
          final titleMatches = journal.title.toLowerCase().contains(query);
          final descriptionMatches = journal.description.toLowerCase().contains(query);
          return titleMatches || descriptionMatches;
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return Scaffold(
      backgroundColor: themeManager.themeMode.value == ThemeMode.dark ? darkmodeLight : backgroundColorLight,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Height20(),
                PrimaryPadding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const CircleAvatar(
                          backgroundColor: kSSIorange,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                      const Width20(),
                      Text(
                        'Journal',
                        style: titleStyle.copyWith(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                const Height20(),

                // Updated search bar with circular shape, smaller height, and white background
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search your notes',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: themeManager.themeMode.value == ThemeMode.dark ? darkmodeFore : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10), // Smaller height
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Circular shape
                        borderSide: BorderSide.none, // No border
                      ),
                    ),
                  ),
                ),
                const Height20(),

                Expanded(
                  child: Center(
                    child: isLoading
                      ? const CircularProgressIndicator()
                      : filteredJournals.isEmpty
                        ? ValueListenableBuilder<ThemeMode>(
                            valueListenable: themeManager.themeMode,
                            builder: (context, theme, snapshot) {
                              return Text(
                                _searchController.text.isEmpty ? 'No Journals' : 'No journal found',
                                style: TextStyle(
                                  color: theme == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black),
                              );
                            })
                        : buildJournalEntries(),
                  ),
                ),
              ],
            ),
            // Floating Action Button at the bottom right
            Positioned(
              bottom: 20,
              right: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  foregroundColor: Colors.white,
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddEditJournalPage(),
                      ),
                    );
                    refreshJournals(); // Refresh the journal list after adding an entry
                  },
                  backgroundColor: kSSIorange,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJournalEntries() => MasonryGridView.count(
  padding: const EdgeInsets.all(8),
  itemCount: filteredJournals.length,
  crossAxisCount: 2, // 2 columns for fit-like behavior (adjust as needed)
  mainAxisSpacing: 4,
  crossAxisSpacing: 4,
  itemBuilder: (context, index) {
    final journalEntry = filteredJournals[index];
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
              AddEditJournalPage(journalEntry: journalEntry),
          ),
        );
        refreshJournals();
      },
      child: JournalCard(journalEntry: journalEntry, index: index),
    );
  },
);

  // Widget buildJournalEntries() => StaggeredGridView.countBuilder(
  //   padding: const EdgeInsets.all(8),
  //   itemCount: journals.length,
  //   crossAxisCount: 4,
  //   mainAxisSpacing: 4,
  //   crossAxisSpacing: 4,
  //   staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
  //   itemBuilder: (context, index) {
  //     final journalEntry = journals[index];

  //     return GestureDetector(
  //       onTap: () async {
  //         await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) =>
  //               AddEditJournalPage(journalEntry: journalEntry),
  //           ),
  //         );
  //         refreshJournals();
  //       },
  //       child: JournalCard(journalEntry: journalEntry, index: index),
  //     );
  //   });
}