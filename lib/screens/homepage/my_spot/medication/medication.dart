import 'package:youthspot/global_widgets/primary_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../db/app_db.dart';
import '../../../../db/models/medicine_model.dart';
import '../../../../global_widgets/pill_button_2.dart';
import '../../../../global_widgets/primary_button.dart';
import '../../../../global_widgets/primary_container.dart';
import '../../../../global_widgets/primary_divider.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../../../../global_widgets/section_header.dart';
import '../../../../global_widgets/snack_pill.dart';
import '../../../../providers/medication_provider.dart';
import '../../../../services/services_locator.dart';

import 'add_medication.dart';
import 'widgets/medicationInfoHeader/medication_info_header.dart';
import 'widgets/medicine_doses_dialog.dart';

class Medication extends StatefulWidget {
  const Medication({super.key});

  @override
  State<Medication> createState() => _MedicationState();
}

class _MedicationState extends State<Medication> {
  late List<Medicine> medication;
  bool isLoading = false;
  ValueNotifier<DateTime> selectedDateNotifier = ValueNotifier<DateTime>(
    DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    refreshMedicine();
  }

  @override
  void dispose() {
    // SSIDatabase.instance.close();
    super.dispose();
  }

  Future refreshMedicine() async {
    setState(() => isLoading = true);
    medication = await SSIDatabase.instance.readAllMedication();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Height20(),
          PrimaryPadding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Medication', style: headingStyle),
                PillButton2(
                  title: 'Add',
                  icon: const Icon(Icons.add, color: Colors.white),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddMedicationPage(),
                      ),
                    );
                    refreshMedicine();
                  },
                ),
              ],
            ),
          ),
          const Height20(),
          const PrimaryPadding(child: MedicationInfoHeader()),
          const Height20(),
          const PrimaryDivider(),
          const Height10(),
          const PrimaryPadding(child: SectionHeader(title: 'My Medication')),
          const Height20(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : medication.isEmpty
                ? const PrimaryPadding(
                    child: PrimaryContainer(
                      child: Center(
                        child: Text(
                          'No Medication Added',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
                : buildMedicationList(),
          ),
          const Height20(),
        ],
      ),
    );
  }

  Color setBgColor(int color) {
    switch (color) {
      case 0:
        return const Color(0xFFCBEFED);
      case 1:
        return const Color(0xFFEEE1FF);
      case 2:
        return const Color(0xFFFBE0D7);
      case 3:
        return const Color(0xFFFFE0E9);
      default:
        return const Color(0xFF248d92);
    }
  }

  Color setIconBgColor(int color) {
    switch (color) {
      case 0:
        return const Color(0xFF248d92);
      case 1:
        return const Color(0xFF696db0);
      case 2:
        return const Color(0xFFeb683b);
      case 3:
        return const Color(0xFFff3061);

      default:
        return const Color(0xFF248d92);
    }
  }

  bool isMedicineToday(
    DateTime startDay,
    DateTime endDay,
    DateTime selectedDate,
  ) {
    DateTime start = DateTime(startDay.year, startDay.month, startDay.day);
    DateTime end = DateTime(endDay.year, endDay.month, endDay.day);
    DateTime selected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    if (selected.isAfter(end) || selected.isBefore(start)) {
      return false;
    }
    return true;
  }

  Widget buildMedicationList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: medication.length,
      itemBuilder: (context, index) {
        final medicine = medication[index];
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: getIt<ThemeManager>().themeMode,
          builder: (context, theme, snapshot) {
            return GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print(medicine.doses);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: PrimaryPadding(
                  child: PrimaryContainer(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => MedicineDoseDialog(
                          medicineDoses: medicine.doses,
                          startDate: medicine.startDate, // Pass startDate
                          endDate: medicine.endDate,
                        ),
                      );
                    },
                    bgColor: theme == ThemeMode.dark
                        ? const Color(0xFF1C1C24)
                        : setBgColor(medicine.color),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              mainBorderRadius,
                            ),
                            color: Colors.white
                          ),
                          child: Image.asset(
                            medicine.medicineType == 'pill'
                                ? 'assets/icon/pill_small.png'
                                : medicine.medicineType == 'capsule'
                                ? 'assets/icon/pill.png'
                                : medicine.medicineType == 'syrup'
                                ? 'assets/icon/syrup_icon.png'
                                : 'assets/icon/syrup_icon.png',
                            height: 30,
                            width: 30,
                          ),
                        ),
                        const Width20(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medicine.medicineName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Height10(),
                              Row(
                                children: [
                                  SnackPill(
                                    pillColor: Colors.green,
                                    title: medicine.medicineType,
                                  ),
                                  const Width10(),
                                  Text(
                                    medicine.doses.length == 1
                                        ? "${medicine.doses.length} dose per day"
                                        : "${medicine.doses.length} doses per day",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Width10(),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(mainBorderRadius),
                                  topRight: Radius.circular(mainBorderRadius),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 200,
                                  child: PrimaryPadding(
                                    child: Column(
                                      children: [
                                        const Height20(),
                                        PrimaryButton(
                                          label: 'Edit',
                                          customBackgroundColor:
                                              Colors.blueGrey,
                                          onTap: () async {
                                            Navigator.pop(context);
                                            bool refresh = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddMedicationPage(
                                                      medicine: medicine,
                                                    ),
                                              ),
                                            );
                                            if (refresh) {
                                              refreshMedicine();
                                            }
                                          },
                                        ),
                                        const Height20(),
                                        PrimaryButton(
                                          label: 'Delete',
                                          customBackgroundColor: Colors.red,
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            bool refresh = await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  ConfirmMedicineDeleteDialog(
                                                    medicine: medicine,
                                                  ),
                                            );
                                            if (refresh) {
                                              refreshMedicine();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.more_vert_rounded,
                            weight: .3,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ConfirmMedicineDeleteDialog extends StatelessWidget {
  const ConfirmMedicineDeleteDialog({super.key, required this.medicine});

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<Object>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainBorderRadius),
          ),
          backgroundColor: theme == ThemeMode.dark
              ? backgroundColorDark
              : backgroundColorLight,
          title: Text(
            'Delete Medicine',
            style: titleStyle.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want permanently delete this entry? This action cannot be reversed.',
                style: TextStyle(fontSize: 18),
              ),
              const Height20(),
              const Height10(),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: "Cancel",
                      customBackgroundColor: kSSIorange,
                      onTap: () {
                        Navigator.pop(
                          context,
                          false,
                        ); // Return false to indicate no refresh
                      },
                    ),
                  ),
                  const Width20(),
                  Expanded(
                    child: PrimaryButton(
                      label: "Delete",
                      customBackgroundColor: Colors.blueGrey.withValues(
                        alpha: 0.3,
                      ),
                      onTap: () async {
                        final medicationProvider =
                            Provider.of<MedicationProvider>(
                              context,
                              listen: false,
                            );

                        await medicationProvider.deleteMedication(
                          medicine,
                        ); // Use provider to delete

                        // Close the confirm delete dialog
                        Navigator.of(
                          context,
                        ).pop(true); // Return true to indicate refresh
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
