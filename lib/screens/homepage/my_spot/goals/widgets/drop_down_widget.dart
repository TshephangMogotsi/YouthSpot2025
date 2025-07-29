import 'package:flutter/material.dart';

import '../../../../../../config/constants.dart';
import '../../../../../../config/theme_manager.dart';
import '../../../../../../services/services_locator.dart';

class DropDownWithIcons extends StatefulWidget {
  const DropDownWithIcons({
    super.key,
    required this.onDropDownOptionSelected,
    this.initialValue, // Add this parameter
  });

  final Function(String) onDropDownOptionSelected;
  final String? initialValue; // Optional initial value

  @override
  State<DropDownWithIcons> createState() => _DropDownWithIconsState();
}

class _DropDownWithIconsState extends State<DropDownWithIcons> {
  final List<String> dropdownOptions = [
    'Financial',
    'Fitness',
    'Diet & Nutrition',
    'Medication',
    'Study',
    'Mindset',
    'Reading',
    'Time Management',
    'Meditation',
    'Relationships',
    'Lifestyle',
  ];

  late String selectedOption;

  @override
  void initState() {
    super.initState();
    // Use the provided initial value, or default to the first option
    selectedOption = widget.initialValue ?? dropdownOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: theme == ThemeMode.light ? Colors.white : darkmodeFore,
              
              borderRadius: BorderRadius.circular(50),
             
            ),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(mainBorderRadius),
              isExpanded: true,
              value: selectedOption,
                dropdownColor: theme == ThemeMode.dark
                      ? darkmodeFore
                      : Colors.white,
              items: dropdownOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  
                  child: Row(
                    children: [
                      Icon(getIconForOption(value)),
                      const SizedBox(width: 10),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
                widget.onDropDownOptionSelected(selectedOption);
              },
              hint: const Text('Select an option'),
              underline: Container(),
            ),
          );
        });
  }

  IconData getIconForOption(String option) {
    switch (option) {
      case 'Financial':
        return Icons.attach_money;
      case 'Fitness':
        return Icons.fitness_center;
      case 'Diet & Nutrition':
        return Icons.restaurant;
      case 'Medication':
        return Icons.local_pharmacy;
      case 'Study':
        return Icons.book;
      case 'Mindset':
        return Icons.self_improvement;
      case 'Reading':
        return Icons.menu_book;
      case 'Time Management':
        return Icons.access_time;
      case 'Meditation':
        return Icons.spa;
      case 'Relationships':
        return Icons.favorite;
      case 'Lifestyle':
        return Icons.style;
      default:
        return Icons.help_outline;
    }
  }
}
