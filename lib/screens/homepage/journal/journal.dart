import 'package:youthspot/db/models/journal_model.dart' show JournalEntry;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:showcaseview/showcaseview.dart';

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
  bool isLoading = false;

  final GlobalKey _addButtonKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

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

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ShowCaseWidget(
      builder: (BuildContext showcaseContext) {
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
                          : journals.isEmpty
                            ? ValueListenableBuilder<ThemeMode>(
                                valueListenable: themeManager.themeMode,
                                builder: (context, theme, snapshot) {
                                  return Text(
                                    'No Journals',
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
                  child: Showcase(
                    key: _addButtonKey,
                    description: 'Add a new journal entry.',
                    disposeOnTap: false,
                    onTargetClick: () => _scrollToKey(_addButtonKey),
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
                ),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     ShowCaseWidget.of(showcaseContext).startShowCase([
          //       _addButtonKey,
          //     ]);
          //   },
          //   child: const Icon(Icons.play_arrow),
          // ),
        );
      },
    );
  }

  Widget buildJournalEntries() => MasonryGridView.count(
  padding: const EdgeInsets.all(8),
  itemCount: journals.length,
  crossAxisCount: 2, // 2 columns for fit-like behavior (adjust as needed)
  mainAxisSpacing: 4,
  crossAxisSpacing: 4,
  itemBuilder: (context, index) {
    final journalEntry = journals[index];
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