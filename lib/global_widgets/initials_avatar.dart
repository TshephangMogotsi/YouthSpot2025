import 'package:flutter/material.dart';
import 'package:youthspot/config/font_constants.dart';

class InitialsAvatar extends StatelessWidget {
  final String fullName;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;

  const InitialsAvatar({
    super.key,
    required this.fullName,
    this.radius = 25,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
  });

  /// Extracts initials from a full name
  /// Example: "John Doe" -> "JD", "Alice" -> "A", "Mary Jane Smith" -> "MS"
  static String getInitials(String fullName) {
    if (fullName.trim().isEmpty) return '';
    
    final nameParts = fullName.trim().split(RegExp(r'\s+'));
    
    if (nameParts.length == 1) {
      // Single name, return first character
      return nameParts[0].substring(0, 1).toUpperCase();
    } else {
      // Multiple names, return first character of first and last name
      final firstInitial = nameParts.first.substring(0, 1).toUpperCase();
      final lastInitial = nameParts.last.substring(0, 1).toUpperCase();
      return '$firstInitial$lastInitial';
    }
  }

  /// Generates a color based on the full name for consistent avatar colors
  static Color generateBackgroundColor(String fullName) {
    if (fullName.isEmpty) return Colors.grey.shade400;
    
    final hash = fullName.hashCode;
    final colors = [
      const Color(0xFF6B73FF),
      const Color(0xFF9B59B6),
      const Color(0xFF3498DB),
      const Color(0xFF1ABC9C),
      const Color(0xFF2ECC71),
      const Color(0xFFF39C12),
      const Color(0xFFE67E22),
      const Color(0xFFE74C3C),
      const Color(0xFF95A5A6),
      const Color(0xFF34495E),
    ];
    
    return colors[hash.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final initials = getInitials(fullName);
    final bgColor = backgroundColor ?? generateBackgroundColor(fullName);
    final txtColor = textColor ?? Colors.white;
    final fSize = fontSize ?? (radius * 0.6); // Default font size relative to radius

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Text(
        initials,
        style: AppTextStyles.primaryBold.copyWith(
          color: txtColor,
          fontSize: fSize,
        ),
      ),
    );
  }
}