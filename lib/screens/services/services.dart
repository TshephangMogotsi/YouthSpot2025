import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/services_provider.dart';  // Import your ServiceProvider
import '../../config/constants.dart';
import '../../config/theme_manager.dart';
import '../../services/services_locator.dart';
import '../../global_widgets/custom_app_bar.dart';
import '../../global_widgets/primary_padding.dart';
import 'widgets/directory_tile.dart';
import 'loading_shimmer.dart';  // Import your shimmer loading widget

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    final serviceProvider = Provider.of<ServiceProvider>(context);

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
          body: serviceProvider.services.isEmpty
              ? const LoadingShimmer()  // Show shimmer if no services are loaded yet
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: serviceProvider.services.length,
                  itemBuilder: (context, index) {
                    final service = serviceProvider.services[index].data() as Map<String, dynamic>;
                    return PrimaryPadding(
                      child: CustomDirectoryTile(
                        title: service['name'],
                        trailing: Icons.expand_more,
                        imageURL: service['image'],  // Image URL from Firestore
                        borderVisible: false,
                        location: service['location'],
                        latitude: double.parse(service['lat'].toString()),
                        longitude: double.parse(service['lng'].toString()),
                        contact: service['contacts'],
                        onCall: () {
                          Uri dialNumber =
                              Uri(scheme: 'tel', path: service['contacts']);
                          launchUrl(dialNumber);
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
