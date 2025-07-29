import 'package:flutter/material.dart';
import '../db/app_db.dart';
import '../db/models/medicine_model.dart';

class MedicationProvider with ChangeNotifier {
  List<Medicine> _medications = [];
  bool _isLoading = false;

  List<Medicine> get medications => _medications;
  bool get isLoading => _isLoading;

  Future<void> fetchMedications() async {
    _setLoading(true);
    _medications = await SSIDatabase.instance.readAllMedication();
    _setLoading(false);
  }

  Future<Medicine> addMedication(Medicine medicine) async {
    final newMedicine = await SSIDatabase.instance.createMedicine(medicine);
    await fetchMedications(); // Refresh the medication list
    return newMedicine; // Return the new medicine object with ID
  }

  Future<void> updateMedication(Medicine medicine) async {
    await SSIDatabase.instance.updateMedicine(medicine);
    await fetchMedications(); // Refresh the medication list
  }

  Future<void> deleteMedication(Medicine medicine) async {
    await SSIDatabase.instance.deleteMedication(medicine.id!);
    await fetchMedications(); // Refresh the medication list
  }

  Future<void> deleteInactiveMedications() async {
    DateTime now = DateTime.now();
    _medications = await SSIDatabase.instance.readAllMedication();
    for (var medication in _medications) {
      if (medication.endDate.isBefore(now)) {
        await SSIDatabase.instance.deleteMedication(medication.id!);
      }
    }
    fetchMedications();
  }

  List<Medicine> getActiveMedications() {
    DateTime now = DateTime.now();
    return _medications.where((medication) => medication.endDate.isAfter(now)).toList();
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}