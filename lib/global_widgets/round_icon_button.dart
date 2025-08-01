import 'package:flutter/material.dart';
import 'package:youthspot/config/constants.dart';
import '../config/theme_manager.dart';
import '../services/services_locator.dart';

class RoundIconButton extends StatefulWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onClick,
  });

  final IconData icon;
  final VoidCallback onClick;

  @override
  State<RoundIconButton> createState() => _RoundIconButtonState();
}

class _RoundIconButtonState extends State<RoundIconButton> {
  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return RawMaterialButton(
          onPressed: widget.onClick,
          elevation: theme == ThemeMode.dark ? 0.0 : 0.0,
          shape: const CircleBorder(),
          constraints: const BoxConstraints.tightFor(
            width: 56.0,
            height: 56.0,
          ),
          fillColor: theme == ThemeMode.dark
              ? const Color(0xFF2A2A34)
              : kSSIorange,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        );
      },
    );
  }
}