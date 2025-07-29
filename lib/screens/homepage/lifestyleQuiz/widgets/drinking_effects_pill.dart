import 'package:flutter/material.dart';

import '../../../../config/constants.dart';

class DrinkingEffectsPill extends StatelessWidget {
  const DrinkingEffectsPill({
    super.key,
    required this.index,
    required this.drinkingEffects,
    required this.onTap,
  });

  final int index;
  final List<String> drinkingEffects;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color:  kSSIorange,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          drinkingEffects[index],
        ),
      ),
    );
  }
}