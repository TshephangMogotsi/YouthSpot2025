import 'package:youthspot/screens/Account/account.dart';
import 'package:youthspot/screens/homepage.dart';
import 'package:youthspot/screens/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'article_page.dart';
import 'config/constants.dart';
import 'config/theme_manager.dart';
import 'services/services_locator.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  // Define the pages for the bottom navigation bar
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    DocumentPage(), // Home
    ArticlePage(), // Resources
    Placeholder(), // Services
    Account(), // Leaderboard
    // DocumentPage(),
    // Services(),
    // Leaderboard(),
    // Settings(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle changes
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up observer
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, child) {
        return Scaffold(
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: theme == ThemeMode.dark
                ? const Color(0xFF0A0A0A)
                : backgroundColorLight,
            selectedItemColor: kSSIorange,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 0
                      ? 'assets/icon/Home.svg'
                      : 'assets/icon/home_outline.svg',
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 0 ? kSSIorange : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 1
                      ? 'assets/icon/folder.svg'
                      : 'assets/icon/folder_outline.svg',
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 1 ? kSSIorange : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Resources',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 2
                      ? 'assets/icon/Services.svg'
                      : 'assets/icon/services_outline.svg',
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 2 ? kSSIorange : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Services',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 3
                      ? 'assets/icon/trophy.svg'
                      : 'assets/icon/trophy_outline.svg',
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 3 ? kSSIorange : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Leaderboard',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 4
                      ? 'assets/icon/profile.svg'
                      : 'assets/icon/profile_outline.svg',
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 4 ? kSSIorange : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Account',
              ),
            ],
          ),
        );
      },
    );
  }
}

// import 'package:auth_template/auth/auth_service.dart';
// import 'package:auth_template/profile/change_password.dart';
// import 'package:auth_template/profile/delete_profile.dart';
// import 'package:auth_template/profile/update_username.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   late String username;

//   @override
//   void initState() {
//     super.initState();
//     username = authService.value.currentUser?.displayName ?? 'Username';
//     authService.addListener(_updateUsername);
//   }

//   void _updateUsername() {
//     setState(() {
//       username = authService.value.currentUser?.displayName ?? 'Username';
//     });
//   }

//   @override
//   void dispose() {
//     authService.removeListener(_updateUsername);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     final email = user?.email ?? 'flutter@pro.com';

//     //show error snackbar
//     void showErrorSnackbar(String errorMessage) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           content: Text(errorMessage),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }

//     void logout() async {
//       try {
//         await authService.value.signOut();
//         // Optionally navigate to login page
//       } on FirebaseAuthException catch (e) {
//         // Handle error
//         showErrorSnackbar(e.message ?? 'An unknown error occurred');
//       }
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFF101010),
//       appBar: AppBar(
//         title: const Text('My Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 16),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1A1A1A),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.green),
//             ),
//             child: Column(
//               children: [
//                 const Text(
//                   '😊',
//                   style: TextStyle(fontSize: 40),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   authService.value.currentUser!.displayName ?? 'Username',
//                   style: const TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   email,
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Settings',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           _SettingsItem(
//               title: 'Update username',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const UpdateUsernamePage(),
//                   ),
//                 ).then((_) {
//                   setState(
//                       () {}); // <-- Add this inside your ProfilePage's StatefulWidget to refresh
//                 });
//               }),
//           _SettingsItem(
//               title: 'Change password',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const ChangePasswordPage(),
//                   ),
//                 );
//               }),
//           _SettingsItem(
//               title: 'Delete my account',
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const DeleteAccountPage(),
//                   ),
//                 );
//               }),
//           _SettingsItem(title: 'About this app', onTap: () {}),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             child: GestureDetector(
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       backgroundColor: const Color(0xFF1A1A1A),
//                       title: const Text(
//                         'Confirm Logout',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       content: const Text(
//                         'Are you sure you want to log out?',
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(),
//                           child: const Text('Cancel',
//                               style: TextStyle(color: Colors.grey)),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop(); // Close dialog
//                             logout(); // Proceed to logout
//                           },
//                           child: const Text('Logout',
//                               style: TextStyle(color: Colors.red)),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               child: const Text(
//                 'Logout',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: const Color(0xFF1A1A1A),
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.white70,
//         currentIndex: 1,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.explore),
//             label: 'Explore',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'My Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SettingsItem extends StatelessWidget {
//   final String title;
//   final VoidCallback onTap;

//   const _SettingsItem({
//     required this.title,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(
//         title,
//         style: const TextStyle(color: Colors.white),
//       ),
//       trailing: const Icon(Icons.chevron_right, color: Colors.white),
//       onTap: onTap,
//     );
//   }
// }
