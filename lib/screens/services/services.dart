import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youthspot/db/models/service_model.dart';
import 'package:youthspot/services/service_service.dart';
import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';
import '../../global_widgets/custom_app_bar.dart';
import '../../global_widgets/primary_padding.dart';
import 'widgets/directory_tile.dart';
import 'loading_shimmer.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final ServiceService _serviceService = ServiceService();
  List<Service> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final services = await _serviceService.fetchServices();
      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoading = false;
      });
      // You could show an error snackbar here if needed
      print('Error fetching services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return Scaffold(
          backgroundColor: theme == ThemeMode.dark
              ? darkmodeLight
              : backgroundColorLight,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: CustomAppBar(
              context: context,
              isHomePage: true,
            ),
          ),
          body: _isLoading
              ? const LoadingShimmer()  // Show shimmer while loading
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    final service = _services[index];
                    return PrimaryPadding(
                      child: CustomDirectoryTile(
                        title: service.name,
                        trailing: Icons.expand_more,
                        imageURL: service.imageUrl ?? '',  // Use imageUrl from Service model
                        borderVisible: false,
                        location: service.location ?? 'No location provided',
                        latitude: service.latitude ?? 0.0,
                        longitude: service.longitude ?? 0.0,
                        contact: service.contacts?.isNotEmpty == true ? service.contacts!.first : 'No contact provided',
                        onCall: () {
                          if (service.contacts?.isNotEmpty == true) {
                            Uri dialNumber = Uri(scheme: 'tel', path: service.contacts!.first);
                            launchUrl(dialNumber);
                          }
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
