import 'package:flutter/material.dart';

import '../models/ayurveda_models.dart';

class PatientNotifier extends ChangeNotifier {
  PatientNotifier() {
    _selectedPatientId = _patients.first.id;
    _seedPlans();
  }

  final List<PatientProfile> _patients = [
    const PatientProfile(
      id: 'patient_anita',
      name: 'Anita Rao',
      age: 34,
      gender: 'Female',
      weight: 68.0,
      lifestyle: 'Desk job · Evening yoga · Urban lifestyle',
      prakriti: 'Pitta',
      digestionQuality: 'Sharp but acid-prone',
      bowelMovements: 'Regular · Occasionally loose',
      waterIntake: '2.8 L / day',
      healthTags: ['Pitta dominant', 'Acidity', 'Weight loss'],
      focusAreas: [
        'Soothe acidity',
        'Sustain energy throughout clinic hours',
        'Improve sleep quality'
      ],
      notes:
          'Prefers seasonal vegetables, avoids deep fried snacks, compliant with follow-ups.',
    ),
    const PatientProfile(
      id: 'patient_isha',
      name: 'Isha Mehta',
      age: 27,
      gender: 'Female',
      weight: 54.0,
      lifestyle: 'Startup founder · Irregular meals · Late nights',
      prakriti: 'Vata',
      digestionQuality: 'Variable appetite · Gas & bloating',
      bowelMovements: 'Dry · Alternate day',
      waterIntake: '1.6 L / day',
      healthTags: ['Vata dominant', 'Constipation', 'Anxiety'],
      focusAreas: [
        'Stabilise digestion',
        'Restore bowel regularity',
        'Calm nervous system'
      ],
      notes: 'Enjoys fusion food; needs simple prep ideas and grocery lists.',
    ),
    const PatientProfile(
      id: 'patient_rahul',
      name: 'Rahul Singh',
      age: 42,
      gender: 'Male',
      weight: 86.0,
      lifestyle: 'Corporate executive · High stress · Weekend sports',
      prakriti: 'Kapha',
      digestionQuality: 'Sluggish in mornings',
      bowelMovements: 'Regular but heavy',
      waterIntake: '2.2 L / day',
      healthTags: ['Kapha dominant', 'Prediabetes', 'Weight loss'],
      focusAreas: [
        'Improve metabolic fire',
        'Support lipid profile',
        'Keep meals travel-friendly'
      ],
      notes: 'Frequent travel; appreciates batch-cooked options.',
    ),
  ];

  final Map<String, DietPlan> _plansByPatient = {};
  late String _selectedPatientId;
  DietPlan? _activePlan;
  final Map<String, bool> _snackReminderPreference = {};
  final Map<String, bool> _lifestyleTipsPreference = {};

  final List<String> goalOptions = const [
    'Weight Loss',
    'Weight Gain',
    'Digestive Reset',
    'General Wellness',
  ];

  final List<String> activityLevels = const [
    'Sedentary',
    'Moderate',
    'Active',
  ];

  final List<String> prakritiOptions = const [
    'Vata',
    'Pitta',
    'Kapha',
    'Tridoshic',
  ];

  List<PatientProfile> get patients => List.unmodifiable(_patients);
  PatientProfile get selectedPatient =>
      _patients.firstWhere((p) => p.id == _selectedPatientId);
  DietPlan? get activePlan =>
      _activePlan ?? _plansByPatient[_selectedPatientId];

  DietPlan? planForPatient(String patientId) => _plansByPatient[patientId];

  void selectPatient(String patientId) {
    if (_selectedPatientId == patientId) return;
    _selectedPatientId = patientId;
    _activePlan = _plansByPatient[patientId];
    notifyListeners();
  }

  DietPlan generatePlanForPatient({
    required String patientId,
    required String goal,
    required String activityLevel,
    required String prakriti,
    bool includeSnacks = true,
    bool includeLifestyleTips = true,
  }) {
    final patient = _patients.firstWhere((p) => p.id == patientId);
    final normalizedPrakriti =
        prakriti == 'Tridoshic' ? patient.prakriti : prakriti;
    var plan = AyurvedaDietTemplates.buildPlan(
      patient: patient,
      goal: goal,
      activityLevel: activityLevel,
      prakriti: normalizedPrakriti,
    );
    if (!includeSnacks) {
      final filteredMeals = plan.meals
          .where((meal) => meal.slot.toLowerCase() != 'snack')
          .toList(growable: false);
      plan = plan.copyWith(meals: filteredMeals);
    }
    _plansByPatient[patientId] = plan;
    _selectedPatientId = patientId;
    _activePlan = plan;
    _snackReminderPreference[patientId] = includeSnacks;
    _lifestyleTipsPreference[patientId] = includeLifestyleTips;
    notifyListeners();
    return plan;
  }

  void swapMealForPatient(String patientId, String slot) {
    final currentPlan = _plansByPatient[patientId];
    if (currentPlan == null) return;
    final updatedMeals = currentPlan.meals
        .map((meal) => meal.slot == slot ? meal.advanceOption() : meal)
        .toList(growable: false);
    final updatedPlan = currentPlan.copyWith(meals: updatedMeals);
    _plansByPatient[patientId] = updatedPlan;
    if (_selectedPatientId == patientId) {
      _activePlan = updatedPlan;
    }
    notifyListeners();
  }

  void setMealOption({
    required String patientId,
    required String slot,
    required int optionIndex,
  }) {
    final currentPlan = _plansByPatient[patientId];
    if (currentPlan == null) return;
    final updatedMeals = currentPlan.meals.map((meal) {
      if (meal.slot != slot) return meal;
      if (optionIndex < 0 || optionIndex >= meal.options.length) return meal;
      return meal.copyWith(selectedIndex: optionIndex);
    }).toList(growable: false);
    final updatedPlan = currentPlan.copyWith(meals: updatedMeals);
    _plansByPatient[patientId] = updatedPlan;
    if (_selectedPatientId == patientId) {
      _activePlan = updatedPlan;
    }
    notifyListeners();
  }

  DietMeal? mealForPatient(String patientId, String slot) {
    final plan = _plansByPatient[patientId];
    if (plan == null) return null;
    try {
      return plan.meals.firstWhere((meal) => meal.slot == slot);
    } catch (_) {
      return null;
    }
  }

  void _seedPlans() {
    final defaultConfigs = <String, Map<String, String>>{
      'patient_anita': {'goal': 'Weight Loss', 'activity': 'Moderate'},
      'patient_isha': {'goal': 'Digestive Reset', 'activity': 'Sedentary'},
      'patient_rahul': {'goal': 'Weight Loss', 'activity': 'Active'},
    };

    for (final patient in _patients) {
      final config = defaultConfigs[patient.id] ??
          const {'goal': 'General Wellness', 'activity': 'Moderate'};
      final plan = AyurvedaDietTemplates.buildPlan(
        patient: patient,
        goal: config['goal']!,
        activityLevel: config['activity']!,
        prakriti: patient.prakriti,
      );
      _plansByPatient[patient.id] = plan;
      _snackReminderPreference[patient.id] = true;
      _lifestyleTipsPreference[patient.id] = true;
    }
    _activePlan = _plansByPatient[_selectedPatientId];
  }

  bool snackRemindersEnabled(String patientId) =>
      _snackReminderPreference[patientId] ?? true;

  bool lifestyleTipsEnabled(String patientId) =>
      _lifestyleTipsPreference[patientId] ?? true;

  void updateReminderPreference({
    required String patientId,
    required bool enabled,
  }) {
    _snackReminderPreference[patientId] = enabled;
    notifyListeners();
  }

  void updateLifestyleTipsPreference({
    required String patientId,
    required bool enabled,
  }) {
    _lifestyleTipsPreference[patientId] = enabled;
    notifyListeners();
  }
}
