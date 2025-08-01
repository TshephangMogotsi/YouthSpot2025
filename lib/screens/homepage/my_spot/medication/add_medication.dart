import 'package:youthspot/global_widgets/primary_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../db/models/medicine_model.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../global_widgets/full_width_dropdown.dart';
import '../../../../global_widgets/pill_button.dart';
import '../../../../global_widgets/primary_container.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../../../../global_widgets/round_icon_button.dart';
import '../../../../providers/medication_provider.dart';
import '../../../../services/notifications_helper.dart';
import '../../../../services/services_locator.dart';
import '../goals/widgets/date_picker.dart';
import 'widgets/error_dialog.dart';
import 'widgets/medicineTile/medicine_tile.dart';
import 'widgets/time_picker.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({super.key, this.medicine});

  final Medicine? medicine;

  @override
  State<AddMedicationPage> createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  late ScaffoldMessengerState scaffoldMessenger;

  List<TimeOfDay> time = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.medicine != null) {
      _initValues();
      selectedMedicineType = widget.medicine?.medicineType;
    } else {
      time = List<TimeOfDay>.filled(doses, TimeOfDay.now());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  void _initValues() {
    _initializeMedicineName();
    medicineType = widget.medicine?.medicineType;
    doses = widget.medicine?.doses.length ?? 1;
    selectedColorIndex = widget.medicine?.color ?? 0;
    _noteController.text = widget.medicine?.note ?? '';
    _initializeMedicineType();
    _initializeDoseTimes();
  }

  void _initializeMedicineName() {
    if (widget.medicine != null) {
      if (medicineList.contains(widget.medicine!.medicineName)) {
        selectedMedicineName = widget.medicine!.medicineName;
        isOtherMedicineName = false;
      } else {
        _medicineNameController.text = widget.medicine!.medicineName;
        isOtherMedicineName = true;
      }
    }
  }

  void _initializeMedicineType() {
    if (medicineType == 'pill') {
      selectedIndex = 0;
    } else if (medicineType == 'capsule') {
      selectedIndex = 1;
    } else if (medicineType == 'syrup') {
      selectedIndex = 2;
    } else {
      selectedIndex = null;
      isOtherSelected = true;
      _medicineTypeController.text = widget.medicine?.medicineType ?? '';
    }
  }

  void _initializeDoseTimes() {
    if (widget.medicine != null && widget.medicine!.doses.isNotEmpty) {
      time = List<TimeOfDay>.from(widget.medicine!.doses);
    } else {
      time = List<TimeOfDay>.filled(doses, TimeOfDay.now());
    }
  }

  final List<String> medicineList = [
    'Contraceptives',
    'Flagyl',
    'Fluoxetine',
    'Amoxycillin',
    'Diazepam',
    'TAF-ED',
    'Paracetamol',
    'Amitriptyline',
    'Vitamins (A,B,C,D,E,K)',
    'TLD',
    'Allergex',
    'Ceftriaxone',
    'PrEP',
  ];

  final TextEditingController _medicineTypeController = TextEditingController();
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool isOtherSelected = false;
  bool isOtherMedicineName = false;
  int? selectedIndex;
  String? medicineType;
  int doses = 1;
  int selectedColorIndex = 0;
  String? selectedMedicineName;
  String? selectedMedicineType;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return PrimaryScaffold(
        
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              PrimaryPadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Medicine', style: headingStyle),
                    const Height20(),
                    Text('Medicine *', style: formFieldTitle),
                    const Height10(),
                    Opacity(
                      opacity: isOtherMedicineName ? 0.3 : 1,
                      child: IgnorePointer(
                        ignoring: isOtherMedicineName,
                        child: FullWidthDropdownButton(
                          hintText: selectedMedicineName ?? 'Select medicine',
                          showError: false,
                          options: medicineList,
                          onOptionSelect: (option) {
                            setState(() {
                              selectedMedicineName = option;
                            });
                          },
                        ),
                      ),
                    ),
                    const Height10(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isOtherMedicineName,
                          onChanged: (value) {
                            setState(() {
                              medicineType = null;
                              isOtherMedicineName = value!;
                            });
                          },
                          activeColor: kSSIorange,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        const Width10(),
                        Text(
                          'Other',
                          style: subTitleStyle,
                        ),
                      ],
                    ),
                    const Height10(),
                    isOtherMedicineName
                        ? Column(
                            children: [
                              CustomTextField(
                                fillColor: theme == ThemeMode.dark
                                    ? darkmodeFore
                                    : Colors.white,
                                hintText: 'Enter Medicine Name',
                                controller: _medicineNameController,
                                onChanged: (value) {
                                  setState(() {
                                    selectedMedicineType = value;
                                  });
                                },
                              ),
                              const Height20(),
                              const Height10(),
                            ],
                          )
                        : const SizedBox(),
                    const Height10(),
                    Text('Medicine Type *', style: formFieldTitle),
                    const Height10(),
                    Opacity(
                      opacity: isOtherSelected ? 0.3 : 1,
                      child: Row(
                        children: List.generate(
                          3,
                          (index) => Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (index == 0) {
                                    selectedMedicineType = 'pill';
                                    selectedIndex = index;
                                  } else if (index == 1) {
                                    selectedMedicineType = 'capsule';
                                    selectedIndex = index;
                                  } else if (index == 2) {
                                    selectedMedicineType = 'syrup';
                                    selectedIndex = index;
                                  }
                                });
                              },
                              child: MedicineTile(
                                isOtherSelected: isOtherSelected,
                                selectedIndex: selectedIndex,
                                index: index,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Height10(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isOtherSelected,
                          onChanged: (value) {
                            setState(() {
                              medicineType = null;
                              isOtherSelected = value!;
                            });
                          },
                          activeColor: kSSIorange,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        const Width10(),
                        Text(
                          'Other',
                          style: subTitleStyle,
                        ),
                      ],
                    ),
                    isOtherSelected
                        ? CustomTextField(
                            fillColor: theme == ThemeMode.dark
                                ? darkmodeFore
                                : Colors.white,
                            hintText: 'Enter Medicine Type',
                            controller: _medicineTypeController,
                            onChanged: (value) {},
                          )
                        : const SizedBox(),
                    const Height10(),
                    Text(
                      'Note',
                      style: formFieldTitle,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    ValueListenableBuilder<ThemeMode>(
                        valueListenable: themeManager.themeMode,
                        builder: (context, theme, snapshot) {
                          return CustomTextField(
                            maxLines: 4,
                            fillColor: theme == ThemeMode.dark
                                ? darkmodeFore
                                : Colors.white,
                            controller: _noteController,
                            hintText: 'E.g. Take with food',
                            onChanged: (value) {},
                          );
                        }),
                    const Height20(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    color: kSSIorange,
                                  ),
                                  const Width10(),
                                  Text('Start Date', style: formFieldTitle),
                                ],
                              ),
                              const Height10(),
                              PrimaryContainer(
                                child: CustomDatePicker(
                                  labelText: 'Select Start Date',
                                  initialDate: startDate,
                                  showIcon: false,
                                  onDateSelected: (date) {
                                    setState(() {
                                      startDate = date;
                                      if (endDate.isBefore(startDate)) {
                                        endDate = startDate;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Width20(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    color: kSSIorange,
                                  ),
                                  const Width10(),
                                  Text('End Date', style: formFieldTitle),
                                ],
                              ),
                              const Height10(),
                              PrimaryContainer(
                                child: CustomDatePicker(
                                  labelText: 'Select End Date',
                                  initialDate: endDate,
                                  showIcon: false,
                                  onDateSelected: (date) {
                                    setState(() {
                                      if (date.isBefore(startDate)) {
                                        endDate = startDate;
                                      } else {
                                        endDate = date;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Height20(),
                    Text('Reminders per day *', style: formFieldTitle),
                    const Height10(),
                    PrimaryContainer(
                      bgColor: theme == ThemeMode.dark
                          ? const Color(0xFF1C1C24)
                          : Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundIconButton(
                            icon: FontAwesomeIcons.minus,
                            onClick: () {
                              setState(() {
                                if (doses > 1) {
                                  doses--;
                                  time = time.sublist(0, doses);
                                }
                              });
                            },
                          ),
                          const Width20(),
                          Column(
                            children: [
                              Text(
                                'Doses',
                                style: subHeadingStyle,
                              ),
                              const Height10(),
                              Text(
                                '$doses',
                                style: headingStyle,
                              )
                            ],
                          ),
                          const Width20(),
                          RoundIconButton(
                            
                            icon: FontAwesomeIcons.plus,
                            onClick: () {
                              setState(() {
                                if (doses < 10) {
                                  doses++;
                                  time = List<TimeOfDay>.filled(
                                    doses,
                                    TimeOfDay.now(),
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: time.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const Height20(),
                            TimePickerWidget(
                              title: 'Take at:',
                              initialTime: time[index],
                              onTimeSelected: (selectedTime) {
                                setState(() {
                                  time[index] = selectedTime;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const Height20(),
                    Text(
                      'Color',
                      style: titleStyle,
                    ),
                    Wrap(
                      children: List<Widget>.generate(
                        4,
                        (int index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5, right: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColorIndex = index;
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: index == 0
                                    ? const Color(0xFFCBEFED)
                                    : index == 1
                                        ? const Color(0xFF6742A7)
                                        : index == 2
                                            ? const Color(0xFFff6600)
                                            : index == 3
                                                ? const Color(0xFFff5555)
                                                : Colors.white,
                                radius: 14,
                                child: selectedColorIndex == index
                                    ? ValueListenableBuilder<ThemeMode>(
                                        valueListenable: themeManager.themeMode,
                                        builder: (context, theme, snapshot) {
                                          return Icon(
                                            FontAwesomeIcons.check,
                                            color: index == 0
                                                ? const Color.fromARGB(
                                                    255, 0, 114, 108)
                                                : index == 1
                                                    ? const Color.fromARGB(
                                                        255, 255, 255, 255)
                                                    : index == 2
                                                        ? const Color.fromARGB(
                                                            255, 255, 255, 255)
                                                        : index == 3
                                                            ? const Color
                                                                .fromARGB(255,
                                                                255, 255, 255)
                                                            : Colors.white,
                                            size: 18,
                                          );
                                        })
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Height20(),
                    PillButton(
                      title:
                          widget.medicine == null ? 'Add Medicine' : 'Update',
                      backgroundColor: kSSIorange,
                      icon: Icons.add,
                      onTap: () {
                        if (selectedMedicineType == null && !isOtherSelected) {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please select or enter a medicine type.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (medicineType == null &&
                            selectedMedicineName == null &&
                            _medicineNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: pinkClr,
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Please Enter Required fields',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const ErrorDialog();
                                        },
                                      );
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 10,
                                      child: Icon(
                                        Icons.question_mark_sharp,
                                        color: pinkClr,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          addOrUpdateMedicine(context);
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                    const Height20(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> addOrUpdateMedicine(BuildContext context) async {
    final medicationProvider =
        Provider.of<MedicationProvider>(context, listen: false);

    // Ensure selectedMedicineType is not null before proceeding
    if (selectedMedicineType == null && !isOtherSelected) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please select or enter a medicine type.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Ensure selectedMedicineName or _medicineNameController.text is not null or empty
    if (selectedMedicineName == null &&
        _medicineNameController.text.trim().isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter a medicine name.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Ensure doses list is not empty
    if (time.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one dose time.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final medicine = Medicine(
      id: widget.medicine?.id, // Use the existing ID if updating
      medicineName: isOtherMedicineName
          ? _medicineNameController.text.trim()
          : selectedMedicineName!,
      medicineType: isOtherSelected
          ? _medicineTypeController.text.trim()
          : selectedMedicineType!,
      doses: time,
      color: selectedColorIndex,
      note: _noteController.text.trim(),
      startDate: startDate,
      endDate: endDate,
      notificationIds: widget.medicine?.notificationIds ??
          [], // Use existing notification IDs if available
    );

    try {
      if (widget.medicine != null) {
        // Update existing medicine
        await medicationProvider.updateMedication(medicine);
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Medicine updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Insert new medicine
        final newMedicine = await medicationProvider
            .addMedication(medicine); // Get the new medicine with ID

        // Ensure the new medicine ID is assigned
        if (newMedicine.id == null) {
          throw Exception("Failed to assign ID to the new medicine.");
        }

        // Cancel previous notifications for this medicine before scheduling new ones
        await _cancelPreviousNotifications(newMedicine);

        // Schedule notifications for each dose time
        final notificationIds =
            await _scheduleMedicationNotifications(newMedicine);

        // Update the medicine with the new notification IDs
        final updatedMedicine =
            newMedicine.copy(notificationIds: notificationIds);

        // Save the updated medicine with notification IDs
        await medicationProvider.updateMedication(updatedMedicine);

        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Medicine added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Handle any exceptions
      if (kDebugMode) {
        print('Error updating medicine: $e');
      }
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to update medicine: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _cancelPreviousNotifications(Medicine medicine) async {
    // Use a consistent way to generate notification IDs
    for (final notificationId in medicine.notificationIds) {
      await NotificationService.cancelNotification(notificationId);
    }
  }

  int generateNotificationId(Medicine medicine, int doseIndex) {
    // Generate a consistent notification ID based on medicine name and dose index
    return medicine.medicineName.hashCode + doseIndex;
  }

  Future<List<int>> _scheduleMedicationNotifications(Medicine medicine) async {
    List<int> notificationIds = [];
    DateTime currentDate = medicine.startDate;

    while (currentDate.isBefore(medicine.endDate) ||
        currentDate.isAtSameMomentAs(medicine.endDate)) {
      for (int i = 0; i < medicine.doses.length; i++) {
        final doseTime = medicine.doses[i];
        final notificationId = generateNotificationId(medicine, i);

        final notificationTitle = 'Time to take ${medicine.medicineName}';
        final notificationBody = medicine.note.isNotEmpty
            ? 'Note: ${medicine.note}'
            : 'Don\'t forget to take your medication!';

        await NotificationService.scheduleNotification(
          notificationId: notificationId,
          title: notificationTitle,
          body: notificationBody,
          scheduledDate: DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            doseTime.hour,
            doseTime.minute,
          ),
        );

        notificationIds.add(notificationId);
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return notificationIds;
  }
}
