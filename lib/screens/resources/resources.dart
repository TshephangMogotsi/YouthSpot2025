import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../global_widgets/primary_container.dart';
import '../../global_widgets/primary_padding.dart';
import '../../global_widgets/primary_scaffold.dart';
import '../../services/services_locator.dart';
import 'file_downloader.dart';
import 'file_model.dart';
import 'pdf_veiwer.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  final List<String> categories = [
    'health',
    'ready_to_work',
    'relationships',
  ];

  final List<String> ready2workSubcategories = [
    'entrepreneurship_skills',
    'people_skills',
    'work_skills',
    'money_skills',
  ];

  List<PDFDocument> documents = [];
  String? selectedCategory = 'All'; // Default selection for "All"
  String? selectedSubcategory;
  bool isLoading = true;
  Map<String, double> downloadProgressMap = {}; // Track progress for each file

  @override
  void initState() {
    super.initState();
    fetchAllDocuments(); // Fetch all documents when the page is first loaded
  }

  Future<void> fetchAllDocuments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('resources') // Assuming 'resources' is your collection name
        .get();

    // Convert Firestore documents to PDFDocument model
    setState(() {
      documents = querySnapshot.docs
          .map((doc) => PDFDocument.fromFirestore(doc))
          .toList();
      isLoading = false;
    });
  }

  void showFileInfoDialog(PDFDocument doc) {
    // Try extracting the file type from the document name first
    String fileType = '';

    // Check if the file name has an extension
    if (doc.name.contains('.')) {
      fileType = doc.name.split('.').last.toUpperCase();
    } else {
      // Fallback to extracting file type from the URL if name does not have an extension
      if (doc.url.contains('.')) {
        fileType = doc.url.split('.').last.split('?').first.toUpperCase();
        // We use split('?').first to remove any potential query parameters in the URL
      }
    }

    // Default to 'Unknown' if no file type is found
    if (fileType.isEmpty) {
      fileType = 'UNKNOWN';
    }

    // Show dialog with file info
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('File Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('File Name: ${doc.name}'),
              const SizedBox(height: 8),
              Text('File Type: $fileType'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<PDFDocument> _getFilteredDocuments() {
    if (selectedCategory == 'All') {
      // Return all documents if 'All' is selected
      return documents;
    } else if (selectedCategory == 'ready_to_work') {
      // Return documents from 'ready_to_work' category, filtered by subcategory if one is selected
      return documents
          .where((doc) =>
              doc.category == 'ready_to_work' &&
              (selectedSubcategory == null ||
                  doc.subcategory == selectedSubcategory))
          .toList();
    } else {
      // Return documents from the selected category
      return documents
          .where((doc) => doc.category == selectedCategory)
          .toList();
    }
  }

  void showCustomSnackBar(BuildContext context, String message) {
    // Overlay entry to manually show and hide the custom snack bar
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20, // Set the position of the snack bar
        left: 20,
        right: 20,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: 0.0),
          duration: const Duration(seconds: 4),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
          child: Material(
            shape: const StadiumBorder(),
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay entry into the screen
    Overlay.of(context).insert(overlayEntry);

    // Remove the snack bar after the duration ends
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Future<void> downloadFile(PDFDocument doc) async {
    FileDownloader fileDownloader = FileDownloader();

    setState(() {
      downloadProgressMap[doc.url] =
          0.0; // Start tracking progress for the file
    });

    // Pass the current context to the downloadFile function
    await fileDownloader.downloadFile(
      context, // Pass the BuildContext from the widget tree
      doc.url,
      '${doc.name}.pdf',
      (received, total) {
        if (total != -1) {
          setState(() {
            downloadProgressMap[doc.url] = received / total;
          });
        }
      },
    );

    setState(() {
      downloadProgressMap.remove(
          doc.url); // Remove progress tracking once download is complete
    });

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(); // Hide any existing snackbars if present
    showCustomSnackBar(context, 'Downloaded ${doc.name}.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      isHomePage: true,
      child: isLoading
          ? PrimaryPadding(child: _buildShimmerEffect())
          : Column(
              children: [
                // Main category buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 0, left: 8, right: 8),
                  child: Row(
                    children: [
                      _buildPillButton('All'),
                      ...categories
                          .map((category) => _buildPillButton(category)),
                    ],
                  ),
                ),

                // Subcategory buttons if "ready_to_work" is selected
                if (selectedCategory == 'ready_to_work')
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: ready2workSubcategories
                          .map((subcategory) => _buildPillButton(subcategory,
                              isSubcategory: true))
                          .toList(),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                // const Divider(height: 1, color: Colors.grey),
                const SizedBox(
                  height: 20,
                ),

                // List of filtered documents
                Expanded(
                  child: PrimaryPadding(
                    child: PrimaryContainer(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 25),
                      borderColor: bluishClr,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _getFilteredDocuments().length,
                        itemBuilder: (context, index) {
                          List<PDFDocument> filteredDocuments =
                              _getFilteredDocuments();
                          PDFDocument doc = filteredDocuments[index];

                          return _buildPDFContainer(doc);
                        },
                      ),
                    ),
                  ),
                ),
                const Height20(),
              ],
            ),
    );
  }

  // Shimmer effect for a category button
  Widget _buildShimmerCategoryButton() {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Shimmer.fromColors(
              baseColor: theme == ThemeMode.dark
                  ? Colors.grey[900]!
                  : Colors.grey[300]!,
              highlightColor: theme == ThemeMode.dark
                  ? Colors.grey[800]!
                  : Colors.grey[100]!,
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  color: theme == ThemeMode.dark
                      ? Colors.grey[900]!
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildShimmerDocumentContainer() {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return Shimmer.fromColors(
            baseColor:
                theme == ThemeMode.dark ? Colors.grey[900]! : Colors.grey[300]!,
            highlightColor:
                theme == ThemeMode.dark ? Colors.grey[800]! : Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                children: [
                  // Simulate the PDF icon
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: theme == ThemeMode.dark
                          ? Colors.grey[900]!
                          : Colors.grey[400],
                      borderRadius:
                          BorderRadius.circular(5), // Icon-like rectangle
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Simulate the document title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Simulate the document title (first line)
                        Container(
                          height: 15,
                          width: 150, // Adjust the width as needed
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Simulate the "more" button (three dots)
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius:
                          BorderRadius.circular(12.5), // Circular shape
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Function to create a shimmer effect while loading
  Widget _buildShimmerEffect() {
    return Column(
      children: [
        // Shimmer for category buttons
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 0, left: 8, right: 8),
          child: Row(
            children:
                List.generate(3, (index) => _buildShimmerCategoryButton()),
          ),
        ),
        const Height10(),
        const Height10(),

        // Shimmer for document list
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 10, // Simulate 8 loading items
            itemBuilder: (context, index) {
              return _buildShimmerDocumentContainer(); // This now has shimmer effect
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPDFContainer(PDFDocument doc) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(mainBorderRadius),
            ),
            margin: const EdgeInsets.only(bottom: 0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.picture_as_pdf_rounded,
                    color: Colors.red[600], size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: theme == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      if (downloadProgressMap.containsKey(doc.url))
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: LinearProgressIndicator(
                            value: downloadProgressMap[
                                doc.url], // Show progress for the specific file
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show bottom sheet when clicking the 3 dots
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.download),
                              title: const Text('Download'),
                              onTap: () async {
                                Navigator.pop(
                                    context); // Close the bottom sheet
                                await downloadFile(
                                    doc); // Call the download function
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.folder_open),
                              title: const Text('Open'),
                              onTap: () {
                                Navigator.pop(
                                    context); // Close the bottom sheet
                                // Navigate to the PDF viewer page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFViewerPage(
                                      url: doc.url, // Pass the document URL
                                      fileName: doc.name, // Pass the file name
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.share),
                              title: const Text('Share'),
                              onTap: () {
                                Navigator.pop(context);
                                SharePlus.instance.share(
                                  ShareParams(text: doc.url),
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.info),
                              title: const Text('Info'),
                              onTap: () {
                                Navigator.pop(
                                    context); // Close the bottom sheet
                                showFileInfoDialog(
                                    doc); // Show file info dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _buildPillButton(String category, {bool isSubcategory = false}) {
    final themeManager = getIt<ThemeManager>();

    bool isSelected = isSubcategory
        ? selectedSubcategory == category
        : selectedCategory == category && selectedSubcategory == null;

    return ValueListenableBuilder<Object>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              showCheckmark: false,
              shape: const StadiumBorder(),
              label: Text(category.replaceAll('_', ' ').capitalize()),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (isSubcategory) {
                    selectedSubcategory = selected ? category : null;
                  } else {
                    selectedCategory = selected ? category : 'All';
                    selectedSubcategory =
                        null; // Reset subcategory if main category changes
                  }
                });
              },
              selectedColor: kSSIorange,
              backgroundColor: theme == ThemeMode.dark
                  ? const Color(0xFF191919)
                  : backgroundColorLight,
              labelStyle: TextStyle(
                  color: isSelected || theme == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
            ),
          );
        });
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
