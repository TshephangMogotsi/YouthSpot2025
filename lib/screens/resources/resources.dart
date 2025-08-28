import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:youthspot/config/font_constants.dart';
import 'package:youthspot/db/models/resource_model.dart';
import 'package:youthspot/providers/resource_provider.dart';

import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../global_widgets/primary_container.dart';
import '../../global_widgets/primary_padding.dart';
import '../../global_widgets/primary_scaffold.dart';
import '../../services/services_locator.dart';
import 'file_downloader.dart';
import 'pdf_veiwer.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  List<Resource> _filteredResources = [];
  ResourceCategory? _selectedCategory;
  ResourceSubcategory? _selectedSubcategory;
  Map<String, double> _downloadProgressMap = {};

  @override
  void initState() {
    super.initState();
    // No need to load data here - ResourceProvider handles it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFilteredResources();
    });
  }

  void _updateFilteredResources() {
    final resourceProvider = context.read<ResourceProvider>();
    final filteredResources = resourceProvider.getFilteredResources(
      selectedCategory: _selectedCategory,
      selectedSubcategory: _selectedSubcategory,
    );
    setState(() {
      _filteredResources = filteredResources;
    });
  }

  void _onCategorySelected(ResourceCategory? category) {
    final resourceProvider = context.read<ResourceProvider>();
    setState(() {
      _selectedCategory = category;
      _selectedSubcategory = null;
    });

    // Clear subcategories first
    resourceProvider.clearSubcategories();

    if (category != null) {
      resourceProvider.fetchSubcategories(category.id);
    }
    _updateFilteredResources();
  }

  void _onSubcategorySelected(ResourceSubcategory? subcategory) {
    setState(() {
      _selectedSubcategory = subcategory;
    });
    _updateFilteredResources();
  }

  void showFileInfoDialog(Resource doc) {
    String fileType = doc.fileType?.toUpperCase() ?? 'UNKNOWN';

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

  void showCustomSnackBar(BuildContext context, String message) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20,
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

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Future<void> downloadFile(Resource doc) async {
    if (doc.url == null) return;
    FileDownloader fileDownloader = FileDownloader();

    setState(() {
      _downloadProgressMap[doc.url!] = 0.0;
    });

    await fileDownloader.downloadFile(
      context,
      doc.url!,
      '${doc.name}.${doc.fileType ?? 'pdf'}',
      (received, total) {
        if (total != -1) {
          setState(() {
            _downloadProgressMap[doc.url!] = received / total;
          });
        }
      },
    );

    setState(() {
      _downloadProgressMap.remove(doc.url);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    showCustomSnackBar(context, 'Downloaded ${doc.name}');
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      isHomePage: true,
      child: Consumer<ResourceProvider>(
        builder: (context, resourceProvider, child) {
          if (resourceProvider.isLoading) {
            return PrimaryPadding(child: _buildShimmerEffect());
          }

          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 0, left: 8, right: 8),
                child: Row(
                  children: [
                    _buildPillButton(null, 'All'),
                    ...resourceProvider.categories.map((category) => _buildPillButton(category, category.name)),
                  ],
                ),
              ),
              if (resourceProvider.subcategories.isNotEmpty)
                Height10(),
              if (resourceProvider.subcategories.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    children: resourceProvider.subcategories
                        .map((subcategory) => _buildPillButton(subcategory, subcategory.name, isSubcategory: true))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 20),
              Expanded(
                child: PrimaryPadding(
                  child: PrimaryContainer(
                    padding: const EdgeInsets.fromLTRB(25,10, 10,10),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredResources.length,
                      itemBuilder: (context, index) {
                        Resource doc = _filteredResources[index];
                        return _buildPDFContainer(doc);
                      },
                    ),
                  ),
                ),
              ),
              const Height20(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerCategoryButton() {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Shimmer.fromColors(
              baseColor: theme == ThemeMode.dark ? Colors.grey[900]! : Colors.grey[300]!,
              highlightColor: theme == ThemeMode.dark ? Colors.grey[800]! : Colors.grey[100]!,
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  color: theme == ThemeMode.dark ? Colors.grey[900]! : Colors.grey[400],
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
            baseColor: theme == ThemeMode.dark ? Colors.grey[900]! : Colors.grey[300]!,
            highlightColor: theme == ThemeMode.dark ? Colors.grey[800]! : Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: theme == ThemeMode.dark ? Colors.grey[900]! : Colors.grey[400],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 15,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildShimmerEffect() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 0, left: 8, right: 8),
          child: Row(
            children: List.generate(3, (index) => _buildShimmerCategoryButton()),
          ),
        ),
        const Height10(),
        const Height10(),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return _buildShimmerDocumentContainer();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPDFContainer(Resource doc) {
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
                Icon(Icons.picture_as_pdf_rounded, color: Colors.red[600], size: 30),
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
                          color: theme == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      if (doc.url != null && _downloadProgressMap.containsKey(doc.url!))
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: LinearProgressIndicator(
                            value: _downloadProgressMap[doc.url!],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.download),
                              title: const Text('Download'),
                              onTap: () async {
                                Navigator.pop(context);
                                await downloadFile(doc);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.folder_open),
                              title: const Text('Open'),
                              onTap: () {
                                Navigator.pop(context);
                                if (doc.url != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PDFViewerPage(
                                        url: doc.url!,
                                        fileName: doc.name,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.share),
                              title: const Text('Share'),
                              onTap: () {
                                Navigator.pop(context);
                                if (doc.url != null) {
                                  SharePlus.instance.share(
                                    ShareParams(text: doc.url!),
                                  );
                                }
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.info),
                              title: const Text('Info'),
                              onTap: () {
                                Navigator.pop(context);
                                showFileInfoDialog(doc);
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

  Widget _buildPillButton(dynamic item, String label, {bool isSubcategory = false}) {
    final themeManager = getIt<ThemeManager>();

    bool isSelected;
    if (isSubcategory) {
      isSelected = _selectedSubcategory == item;
    } else {
      isSelected = _selectedCategory == item;
    }

    return ValueListenableBuilder<Object>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              showCheckmark: false,
              
              shape: const StadiumBorder(
                side: BorderSide(color: Color.fromARGB(50, 158, 158, 158), width: 2),
              ),
              label: Text(label.replaceAll('_', ' ').capitalize()),
              selected: isSelected,
              onSelected: (bool selected) {
                if (isSubcategory) {
                  _onSubcategorySelected(selected ? item as ResourceSubcategory? : null);
                } else {
                  _onCategorySelected(selected ? item as ResourceCategory? : null);
                }
              },
              selectedColor: kSSIorange,
              backgroundColor: theme == ThemeMode.dark ? const Color(0xFF191919) : const Color.fromARGB(255, 255, 255, 255),
              labelStyle: AppTextStyles.secondarySemiBold.copyWith(
                color: isSelected || theme == ThemeMode.dark ? Colors.white : Colors.black,
              ),
              // labelStyle: TextStyle(color: isSelected || theme == ThemeMode.dark ? Colors.white : Colors.black),
            ),
          );
        });
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
