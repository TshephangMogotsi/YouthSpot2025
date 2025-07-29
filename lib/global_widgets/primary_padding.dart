import 'package:flutter/material.dart';

class PrimaryPadding extends StatelessWidget {
  const PrimaryPadding({super.key, required this.child, this.verticalPadding=false});

  final Widget child;
  final bool verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: 20,
        vertical: verticalPadding ? 20 : 0,
      ),
      child: child,
    );
  }
}
