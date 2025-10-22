import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youthspot/providers/services_provider.dart';
import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';
import '../../global_widgets/custom_app_bar.dart';
import '../../global_widgets/empty_state_widget.dart';
import '../../global_widgets/primary_padding.dart';
import 'widgets/directory_tile.dart';
import 'loading_shimmer.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
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
          body: Consumer<ServiceProvider>(
            builder: (context, serviceProvider, child) {
              if (serviceProvider.isLoading) {
                return const LoadingShimmer();
              }
              
              if (serviceProvider.hasError || serviceProvider.services.isEmpty) {
                return EmptyStateWidget(
                  message: serviceProvider.hasError
                      ? 'Content will load when connected'
                      : 'No services available',
                  icon: Icons.business_outlined,
                  onRetry: serviceProvider.hasError ? serviceProvider.retry : null,
                  showRetryButton: serviceProvider.hasError,
                );
              }
              
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: serviceProvider.services.length,
                itemBuilder: (context, index) {
                  final service = serviceProvider.services[index];
                  return PrimaryPadding(
                    child: CustomDirectoryTile(
                      title: service.name,
                      trailing: Icons.expand_more,
                      imageURL: service.imageUrl ?? '',
                      borderVisible: false,
                      location: service.location ?? 'Location not available',
                      latitude: service.latitude ?? 0.0,
                      longitude: service.longitude ?? 0.0,
                      locationUrl: service.locationUrl,
                      contact: service.contacts?.isNotEmpty == true ? service.contacts!.first : 'No contact available',
                      onCall: () {
                        // Phone number copying is now handled directly in the expanding container
                        // No action needed here since the expanding container handles clipboard copying
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
