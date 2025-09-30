import 'package:flutter/material.dart';

// Enhanced Health Data Models for Patient App
class HealthMetrics {
  final DateTime date;
  final int steps;
  final double heartRate;
  final int sleepHours;
  final double waterIntake;
  final int calories;
  final double weight;
  final String mood;
  final List<String> symptoms;
  final Map<String, dynamic> vitals;

  HealthMetrics({
    required this.date,
    required this.steps,
    required this.heartRate,
    required this.sleepHours,
    required this.waterIntake,
    required this.calories,
    required this.weight,
    required this.mood,
    this.symptoms = const [],
    this.vitals = const {},
  });
}

class WearableData {
  final String deviceName;
  final DateTime lastSync;
  final bool isConnected;
  final Map<String, dynamic> metrics;

  WearableData({
    required this.deviceName,
    required this.lastSync,
    required this.isConnected,
    required this.metrics,
  });
}

class MedicationReminder {
  final String id;
  final String name;
  final String dosage;
  final List<TimeOfDay> times;
  final bool isActive;
  final DateTime startDate;
  final DateTime? endDate;

  MedicationReminder({
    required this.id,
    required this.name,
    required this.dosage,
    required this.times,
    required this.isActive,
    required this.startDate,
    this.endDate,
  });
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final DateTime unlockedAt;
  final bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlockedAt,
    required this.isUnlocked,
  });
}

class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.imageUrl,
    this.metadata,
  });
}

class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final int cookingTime;
  final int servings;
  final Map<String, double> nutrition;
  final List<String> ayurvedicBenefits;
  final String difficulty;

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.cookingTime,
    required this.servings,
    required this.nutrition,
    required this.ayurvedicBenefits,
    required this.difficulty,
  });
}

class ProgressEntry {
  final DateTime date;
  final double weight;
  final Map<String, double> measurements;
  final String notes;
  final List<String> photos;
  final double energyLevel;
  final double moodScore;

  ProgressEntry({
    required this.date,
    required this.weight,
    required this.measurements,
    required this.notes,
    required this.photos,
    required this.energyLevel,
    required this.moodScore,
  });
}

// Mock Data Generator for Patient App
class PatientMockData {
  // Apple Health Simulated Data
  static List<HealthMetrics> get weeklyHealthData {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return HealthMetrics(
        date: date,
        steps: 8000 + (index * 500) + (date.weekday * 200),
        heartRate: 68.0 + (index * 2.0),
        sleepHours: 7 + (index % 3),
        waterIntake: 2.0 + (index * 0.3),
        calories: 1800 + (index * 50),
        weight: 65.5 + (index * 0.1),
        mood: ['😊', '😐', '😴', '🤗', '💪', '😔', '🌟'][index],
        symptoms: index % 3 == 0 ? ['Fatigue', 'Headache'] : [],
        vitals: {
          'bloodPressure': '120/80',
          'oxygenSaturation': 98 + (index % 3),
          'temperature': 98.6,
        },
      );
    });
  }

  static WearableData get appleWatchData {
    return WearableData(
      deviceName: 'Apple Watch Series 9',
      lastSync: DateTime.now().subtract(const Duration(minutes: 5)),
      isConnected: true,
      metrics: {
        'todaySteps': 12847,
        'heartRateZones': {
          'resting': 65,
          'fat_burn': 95,
          'cardio': 130,
          'peak': 165,
        },
        'workouts': [
          {'type': 'Walking', 'duration': 32, 'calories': 145},
          {'type': 'Yoga', 'duration': 45, 'calories': 120},
        ],
        'sleepStages': {
          'deep': 2.5,
          'light': 4.0,
          'rem': 1.5,
        },
      },
    );
  }

  static List<MedicationReminder> get medications {
    return [
      MedicationReminder(
        id: '1',
        name: 'Triphala Churna',
        dosage: '1 tsp with warm water',
        times: [const TimeOfDay(hour: 6, minute: 0)],
        isActive: true,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
      ),
      MedicationReminder(
        id: '2',
        name: 'Ashwagandha',
        dosage: '500mg capsule',
        times: [
          const TimeOfDay(hour: 8, minute: 0),
          const TimeOfDay(hour: 20, minute: 0)
        ],
        isActive: true,
        startDate: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }

  static List<Achievement> get achievements {
    return [
      Achievement(
        id: '1',
        title: '7-Day Streak',
        description: 'Followed diet plan for 7 consecutive days',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
        isUnlocked: true,
      ),
      Achievement(
        id: '2',
        title: 'Water Warrior',
        description: 'Stayed hydrated for 5 days straight',
        icon: Icons.water_drop,
        color: Colors.blue,
        unlockedAt: DateTime.now().subtract(const Duration(days: 3)),
        isUnlocked: true,
      ),
      Achievement(
        id: '3',
        title: 'Sleep Champion',
        description: 'Get 8 hours of sleep for 7 nights',
        icon: Icons.bedtime,
        color: Colors.purple,
        unlockedAt: DateTime.now(),
        isUnlocked: false,
      ),
    ];
  }

  static List<Recipe> get ayurvedicRecipes {
    return [
      Recipe(
        id: '1',
        name: 'Golden Milk Turmeric Latte',
        imageUrl: 'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=400',
        ingredients: [
          '1 cup coconut milk',
          '1 tsp turmeric powder',
          '1/2 tsp ginger powder',
          '1 tsp ghee',
          'Honey to taste'
        ],
        instructions: [
          'Heat coconut milk in a saucepan',
          'Add turmeric and ginger powder',
          'Stir in ghee and simmer for 5 minutes',
          'Add honey and serve warm'
        ],
        cookingTime: 10,
        servings: 1,
        nutrition: {'calories': 180, 'protein': 3, 'carbs': 8, 'fat': 15},
        ayurvedicBenefits: ['Anti-inflammatory', 'Improves digestion', 'Calms Vata'],
        difficulty: 'Easy',
      ),
      Recipe(
        id: '2',
        name: 'Kitchari Bowl',
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
        ingredients: [
          '1/2 cup basmati rice',
          '1/2 cup yellow moong dal',
          '1 tsp cumin seeds',
          '1 tsp turmeric',
          '2 cups water',
          'Salt to taste'
        ],
        instructions: [
          'Wash rice and dal together',
          'Heat ghee, add cumin seeds',
          'Add rice, dal, and spices',
          'Cook with water until soft',
          'Serve hot with ghee'
        ],
        cookingTime: 25,
        servings: 2,
        nutrition: {'calories': 320, 'protein': 12, 'carbs': 58, 'fat': 4},
        ayurvedicBenefits: ['Easy to digest', 'Balances all doshas', 'Detoxifying'],
        difficulty: 'Medium',
      ),
    ];
  }

  static List<ProgressEntry> get progressHistory {
    final now = DateTime.now();
    return List.generate(30, (index) {
      final date = now.subtract(Duration(days: 29 - index));
      return ProgressEntry(
        date: date,
        weight: 65.0 + (index * 0.05),
        measurements: {
          'waist': 32.0 - (index * 0.02),
          'chest': 36.0 + (index * 0.01),
          'hips': 38.0 - (index * 0.015),
        },
        notes: index % 5 == 0 ? 'Feeling great today!' : '',
        photos: [],
        energyLevel: 3.5 + (index * 0.05),
        moodScore: 3.8 + (index * 0.03),
      );
    });
  }
}