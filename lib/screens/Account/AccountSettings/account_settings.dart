import 'package:youthspot/config/constants.dart';
import 'package:youthspot/config/font_constants.dart';
import 'package:youthspot/global_widgets/primary_padding.dart';
import 'package:youthspot/global_widgets/primary_scaffold.dart';
import 'package:flutter/material.dart';

import '../../../global_widgets/primary_container.dart';
import 'widgets/biometric_auth_dialog.dart';
import 'widgets/change_password.dart';
import 'widgets/delete_account_data.dart';
import 'widgets/delete_account_dialog.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      child: PrimaryPadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Account Settings',
                style: AppTextStyles.title,
              ),
            ),
            const SizedBox(height: 20),
            const Height10(),
            AccountSettingsListTile(
              title: 'Change Password',
              assetImage:
                  'assets/icon/Settings/AccountSettings/ResetPassword.png',
              description: 'Change your password',
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) => const ResetPasswordDialog(),
                );
              },
            ),
            const Height10(),
            AccountSettingsListTile(
              title: 'Delete Account',
              assetImage:
                  'assets/icon/Settings/AccountSettings/DeleteAccount.png',
              description: 'Delete your account and all its data.',
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) => const DeleteAccountDialog(),
                );
              },
            ),
            const Height10(),
            AccountSettingsListTile(
              title: 'Delete Account Data',
              assetImage:
                  'assets/icon/Settings/AccountSettings/DeleteAccountData.png',
              description: 'Delete all your account data.',
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) => const DeleteAccountDataDialog(),
                );
              },
            ),
            const Height10(),
            AccountSettingsListTile(
              title: 'Biometric Authentication',
              assetImage:
                  'assets/icon/Settings/AccountSettings/BiometricAuth.png',
              description: 'Manage biometric authentication',
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) => const BiometricAuthDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AccountSettingsListTile extends StatelessWidget {
  const AccountSettingsListTile(
      {super.key,
      required this.title,
      required this.assetImage,
      required this.description,
      this.ontap});

  final String title;
  final String description;
  final String assetImage;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      onTap: ontap,
      borderRadius: BorderRadius.circular(25),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(assetImage, width: 40, height: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.primaryBold),
                Text(description, style: AppTextStyles.secondaryRegular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


