import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youthspot/auth/auth_service.dart';
import 'package:youthspot/auth/auth_switcher.dart';
import 'package:youthspot/config/constants.dart';
import 'package:youthspot/config/font_constants.dart';
import 'package:youthspot/config/theme_manager.dart';
import 'package:youthspot/global_widgets/initials_avatar.dart';
import 'package:youthspot/global_widgets/primary_padding.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';
import 'package:youthspot/providers/account_provider.dart';
import 'package:youthspot/screens/Account/AccountSettings/account_settings.dart';
import 'package:youthspot/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:youthspot/screens/Account/profile.dart';

import '../../description.dart';
import '../../global_widgets/primary_container.dart';
import '../../terms_and_privacy.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  void initState() {
    super.initState();
    // No need to load data here - AccountProvider handles it
  }
  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      isHomePage: true,
      child: PrimaryPadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('Account', style: AppTextStyles.title),
            ),
            const SizedBox(height: 20),
            Consumer<AccountProvider>(
              builder: (context, accountProvider, child) {
                return ProfileListTile(
                  title: 'My Profile',
                  fullName: accountProvider.userFullName,
                  ontap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                );
              },
            ),
            const Height10(),
            SettingsListTile(
              title: 'Account Settings',
              assetImage: 'assets/icon/Settings/SettingsIcon.png',
              ontap: () {
                //push not using pushname
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AccountSettings(),
                  ),
                );
              },
            ),
            const Height10(),
            SettingsListTile(
              title: 'Terms and Conditions',
              assetImage: 'assets/icon/Settings/TermsAndConditionsIcon.png',
              ontap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TermsPrivacyScreen(),
                  ),
                );
              },
            ),
            const Height10(),
            SettingsListTile(
              title: 'Description',
              assetImage: 'assets/icon/Settings/DescriptionIcon.png',
              ontap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DescriptionPage(),
                  ),
                );
              },
            ),
            const Height10(),
            const ThemeModeSelector(),
            const Height20(),
            const Height20(),
            const Height20(),
            GestureDetector(
              onTap: () async {
                final auth = Provider.of<AuthService>(context, listen: false);
                await auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthSwitcher()),
                  (route) => false,
                );
              },

              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                child: const Text(
                  "Logout",
                  style: AppTextStyles.primaryBigSemiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.title,
    required this.assetImage,
    this.ontap,
  });

  final String title;
  final String assetImage;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      onTap: ontap,
      borderRadius: BorderRadius.circular(25),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //icon image
          Image.asset(assetImage, width: 40, height: 40),
          //wallpaper image
          const Width20(),

          Text(title, style: AppTextStyles.primaryBigSemiBold),
        ],
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    super.key,
    required this.title,
    required this.fullName,
    this.ontap,
  });

  final String title;
  final String fullName;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      onTap: ontap,
      borderRadius: BorderRadius.circular(25),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //initials avatar
          InitialsAvatar(fullName: fullName, radius: 25),
          //wallpaper image
          const Width20(),

          Text(title, style: AppTextStyles.primaryBigSemiBold),
        ],
      ),
    );
  }
}

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, themeMode, child) {
        return Column(
          children: [
            // Day Mode Option
            _ThemeModeOption(
              title: 'Day Mode',
              iconData: Icons.wb_sunny,
              isSelected: themeMode == ThemeMode.light,
              onTap: () => themeManager.setThemeMode(ThemeMode.light),
            ),
            const Height10(),
            // Night Mode Option
            _ThemeModeOption(
              title: 'Night Mode',
              iconData: Icons.nightlight_round,
              isSelected: themeMode == ThemeMode.dark,
              onTap: () => themeManager.setThemeMode(ThemeMode.dark),
            ),
            const Height10(),
            // System Default Option
            _ThemeModeOption(
              title: 'System Default',
              iconData: Icons.brightness_auto,
              isSelected: themeMode == ThemeMode.system,
              onTap: () => themeManager.setThemeMode(ThemeMode.system),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  const _ThemeModeOption({
    required this.title,
    required this.iconData,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData iconData;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left section (icon + title)
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.yellow.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  size: 24,
                  color: isSelected ? Colors.yellow.shade700 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Onest',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Right section (selection indicator)
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.yellow : Colors.grey.shade400,
                width: 2,
              ),
              color: isSelected ? Colors.yellow : Colors.transparent,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
