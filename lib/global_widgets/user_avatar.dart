import 'package:flutter/material.dart';
import 'package:youthspot/config/font_constants.dart';

class UserAvatar extends StatelessWidget {
  final String fullName;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const UserAvatar({
    super.key,
    required this.fullName,
    this.radius = 25,
    this.backgroundColor = const Color(0xFF4A90E2),
    this.textColor = Colors.white,
  });

  /// Extract initials from full name
  static String getInitials(String fullName) {
    if (fullName.trim().isEmpty) return '?';
    
    final names = fullName.trim().split(' ');
    if (names.length == 1) {
      return names[0][0].toUpperCase();
    }
    
    return '${names.first[0]}${names.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = getInitials(fullName);
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        initials,
        style: AppTextStyles.primaryBold.copyWith(
          color: textColor,
          fontSize: radius * 0.6, // Scale font size with radius
        ),
      ),
    );
  }
}