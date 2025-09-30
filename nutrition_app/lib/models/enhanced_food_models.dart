import 'package:flutter/material.dart';

// Enhanced food item with Ayurvedic properties
class FoodItem {
  final String id;
  final String name;
  final String category;
  final String subcategory;
  final NutritionData nutrition;
  final AyurvedicProperties ayurvedicProperties;
  final List<String> cuisineTypes;
  final String? imageUrl;
  final String? description;
  final List<String> tags;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final PreparationInfo? preparationInfo;
  final List<String> alternativeNames;

  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.nutrition,
    required this.ayurvedicProperties,
    this.cuisineTypes = const [],
    this.imageUrl,
    this.description,
    this.tags = const [],
    required this.isVegetarian,
    required this.isVegan,
    required this.isGlutenFree,
    this.preparationInfo,
    this.alternativeNames = const [],
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? category,
    String? subcategory,
    NutritionData? nutrition,
    AyurvedicProperties? ayurvedicProperties,
    List<String>? cuisineTypes,
    String? imageUrl,
    String? description,
    List<String>? tags,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    PreparationInfo? preparationInfo,
    List<String>? alternativeNames,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      nutrition: nutrition ?? this.nutrition,
      ayurvedicProperties: ayurvedicProperties ?? this.ayurvedicProperties,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      preparationInfo: preparationInfo ?? this.preparationInfo,
      alternativeNames: alternativeNames ?? this.alternativeNames,
    );
  }
}

// Comprehensive nutrition data
class NutritionData {
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double fiber;
  final double sugar;
  final double sodium;
  final double calcium;
  final double iron;
  final double vitaminC;
  final double vitaminD;
  final double vitaminB12;
  final double folate;
  final double magnesium;
  final double potassium;
  final double zinc;
  final double omega3;
  final double saturatedFat;
  final double cholesterol;

  const NutritionData({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.fiber,
    this.sugar = 0,
    this.sodium = 0,
    this.calcium = 0,
    this.iron = 0,
    this.vitaminC = 0,
    this.vitaminD = 0,
    this.vitaminB12 = 0,
    this.folate = 0,
    this.magnesium = 0,
    this.potassium = 0,
    this.zinc = 0,
    this.omega3 = 0,
    this.saturatedFat = 0,
    this.cholesterol = 0,
  });

  NutritionData multiply(double factor) {
    return NutritionData(
      calories: calories * factor,
      protein: protein * factor,
      carbs: carbs * factor,
      fats: fats * factor,
      fiber: fiber * factor,
      sugar: sugar * factor,
      sodium: sodium * factor,
      calcium: calcium * factor,
      iron: iron * factor,
      vitaminC: vitaminC * factor,
      vitaminD: vitaminD * factor,
      vitaminB12: vitaminB12 * factor,
      folate: folate * factor,
      magnesium: magnesium * factor,
      potassium: potassium * factor,
      zinc: zinc * factor,
      omega3: omega3 * factor,
      saturatedFat: saturatedFat * factor,
      cholesterol: cholesterol * factor,
    );
  }

  NutritionData add(NutritionData other) {
    return NutritionData(
      calories: calories + other.calories,
      protein: protein + other.protein,
      carbs: carbs + other.carbs,
      fats: fats + other.fats,
      fiber: fiber + other.fiber,
      sugar: sugar + other.sugar,
      sodium: sodium + other.sodium,
      calcium: calcium + other.calcium,
      iron: iron + other.iron,
      vitaminC: vitaminC + other.vitaminC,
      vitaminD: vitaminD + other.vitaminD,
      vitaminB12: vitaminB12 + other.vitaminB12,
      folate: folate + other.folate,
      magnesium: magnesium + other.magnesium,
      potassium: potassium + other.potassium,
      zinc: zinc + other.zinc,
      omega3: omega3 + other.omega3,
      saturatedFat: saturatedFat + other.saturatedFat,
      cholesterol: cholesterol + other.cholesterol,
    );
  }
}

// Ayurvedic properties of food
class AyurvedicProperties {
  final List<Rasa> rasas; // Six tastes
  final Virya virya; // Heating/cooling effect
  final Vipaka vipaka; // Post-digestive effect
  final List<Guna> gunas; // Qualities
  final List<Dosha> balancingDoshas;
  final List<Dosha> aggravatingDoshas;
  final DigestibilityLevel digestibility;
  final List<HealthBenefit> healthBenefits;

  const AyurvedicProperties({
    required this.rasas,
    required this.virya,
    required this.vipaka,
    required this.gunas,
    required this.balancingDoshas,
    required this.aggravatingDoshas,
    required this.digestibility,
    this.healthBenefits = const [],
  });
}

// Six tastes in Ayurveda
enum Rasa {
  sweet,
  sour,
  salty,
  pungent,
  bitter,
  astringent,
}

extension RasaExtension on Rasa {
  String get displayName {
    switch (this) {
      case Rasa.sweet:
        return 'Sweet';
      case Rasa.sour:
        return 'Sour';
      case Rasa.salty:
        return 'Salty';
      case Rasa.pungent:
        return 'Pungent';
      case Rasa.bitter:
        return 'Bitter';
      case Rasa.astringent:
        return 'Astringent';
    }
  }

  IconData get icon {
    switch (this) {
      case Rasa.sweet:
        return Icons.cake_outlined;
      case Rasa.sour:
        return Icons.local_drink_outlined;
      case Rasa.salty:
        return Icons.grain_outlined;
      case Rasa.pungent:
        return Icons.local_fire_department_outlined;
      case Rasa.bitter:
        return Icons.eco_outlined;
      case Rasa.astringent:
        return Icons.spa_outlined;
    }
  }

  Color get color {
    switch (this) {
      case Rasa.sweet:
        return const Color(0xFFFFE4B5);
      case Rasa.sour:
        return const Color(0xFFFFB3BA);
      case Rasa.salty:
        return const Color(0xFFE6E6FA);
      case Rasa.pungent:
        return const Color(0xFFFFDAB9);
      case Rasa.bitter:
        return const Color(0xFFD3D3D3);
      case Rasa.astringent:
        return const Color(0xFFF0E68C);
    }
  }
}

// Heating/cooling effect
enum Virya {
  heating,
  cooling,
  neutral,
}

extension ViryaExtension on Virya {
  String get displayName {
    switch (this) {
      case Virya.heating:
        return 'Heating';
      case Virya.cooling:
        return 'Cooling';
      case Virya.neutral:
        return 'Neutral';
    }
  }

  IconData get icon {
    switch (this) {
      case Virya.heating:
        return Icons.local_fire_department;
      case Virya.cooling:
        return Icons.ac_unit;
      case Virya.neutral:
        return Icons.balance;
    }
  }

  Color get color {
    switch (this) {
      case Virya.heating:
        return const Color(0xFFFF6B6B);
      case Virya.cooling:
        return const Color(0xFF4ECDC4);
      case Virya.neutral:
        return const Color(0xFFFFBE0B);
    }
  }
}

// Post-digestive effect
enum Vipaka {
  sweet,
  sour,
  pungent,
}

// Qualities of food
enum Guna {
  heavy,
  light,
  oily,
  dry,
  hot,
  cold,
  smooth,
  rough,
  stable,
  mobile,
}

extension GunaExtension on Guna {
  String get displayName {
    switch (this) {
      case Guna.heavy:
        return 'Heavy';
      case Guna.light:
        return 'Light';
      case Guna.oily:
        return 'Oily';
      case Guna.dry:
        return 'Dry';
      case Guna.hot:
        return 'Hot';
      case Guna.cold:
        return 'Cold';
      case Guna.smooth:
        return 'Smooth';
      case Guna.rough:
        return 'Rough';
      case Guna.stable:
        return 'Stable';
      case Guna.mobile:
        return 'Mobile';
    }
  }
}

// Doshas
enum Dosha {
  vata,
  pitta,
  kapha,
}

extension DoshaExtension on Dosha {
  String get displayName {
    switch (this) {
      case Dosha.vata:
        return 'Vata';
      case Dosha.pitta:
        return 'Pitta';
      case Dosha.kapha:
        return 'Kapha';
    }
  }

  Color get color {
    switch (this) {
      case Dosha.vata:
        return const Color(0xFF90EE90);
      case Dosha.pitta:
        return const Color(0xFFFFD700);
      case Dosha.kapha:
        return const Color(0xFF87CEEB);
    }
  }

  IconData get icon {
    switch (this) {
      case Dosha.vata:
        return Icons.air;
      case Dosha.pitta:
        return Icons.local_fire_department;
      case Dosha.kapha:
        return Icons.water_drop;
    }
  }
}

// Digestibility level
enum DigestibilityLevel {
  veryEasy,
  easy,
  moderate,
  difficult,
  veryDifficult,
}

extension DigestibilityExtension on DigestibilityLevel {
  String get displayName {
    switch (this) {
      case DigestibilityLevel.veryEasy:
        return 'Very Easy';
      case DigestibilityLevel.easy:
        return 'Easy';
      case DigestibilityLevel.moderate:
        return 'Moderate';
      case DigestibilityLevel.difficult:
        return 'Difficult';
      case DigestibilityLevel.veryDifficult:
        return 'Very Difficult';
    }
  }

  Color get color {
    switch (this) {
      case DigestibilityLevel.veryEasy:
        return const Color(0xFF4CAF50);
      case DigestibilityLevel.easy:
        return const Color(0xFF8BC34A);
      case DigestibilityLevel.moderate:
        return const Color(0xFFFFEB3B);
      case DigestibilityLevel.difficult:
        return const Color(0xFFFF9800);
      case DigestibilityLevel.veryDifficult:
        return const Color(0xFFF44336);
    }
  }
}

// Health benefits
class HealthBenefit {
  final String name;
  final String description;
  final IconData icon;

  const HealthBenefit({
    required this.name,
    required this.description,
    required this.icon,
  });
}

// Preparation information
class PreparationInfo {
  final Duration cookingTime;
  final DifficultyLevel difficulty;
  final List<String> cookingMethods;
  final String? recipe;

  const PreparationInfo({
    required this.cookingTime,
    required this.difficulty,
    required this.cookingMethods,
    this.recipe,
  });
}

enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
}

// Food categories
class FoodCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> subcategories;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.subcategories,
  });
}

// Predefined food categories
class FoodCategories {
  static const List<FoodCategory> all = [
    FoodCategory(
      id: 'grains',
      name: 'Grains & Cereals',
      description: 'Rice, wheat, millets, and other grain-based foods',
      icon: Icons.grain,
      color: Color(0xFFD2B48C),
      subcategories: ['Rice', 'Wheat', 'Millets', 'Oats', 'Quinoa'],
    ),
    FoodCategory(
      id: 'vegetables',
      name: 'Vegetables',
      description: 'Fresh vegetables and leafy greens',
      icon: Icons.eco,
      color: Color(0xFF4CAF50),
      subcategories: ['Leafy Greens', 'Root Vegetables', 'Gourds', 'Pods'],
    ),
    FoodCategory(
      id: 'fruits',
      name: 'Fruits',
      description: 'Fresh and dried fruits',
      icon: Icons.apple,
      color: Color(0xFFFF9800),
      subcategories: ['Citrus', 'Tropical', 'Berries', 'Dried Fruits'],
    ),
    FoodCategory(
      id: 'legumes',
      name: 'Legumes & Pulses',
      description: 'Lentils, beans, and other pulses',
      icon: Icons.grass,
      color: Color(0xFF8BC34A),
      subcategories: ['Lentils', 'Beans', 'Chickpeas', 'Peas'],
    ),
    FoodCategory(
      id: 'dairy',
      name: 'Dairy Products',
      description: 'Milk, yogurt, cheese, and other dairy items',
      icon: Icons.local_drink,
      color: Color(0xFF2196F3),
      subcategories: ['Milk', 'Yogurt', 'Cheese', 'Butter', 'Ghee'],
    ),
    FoodCategory(
      id: 'spices',
      name: 'Spices & Herbs',
      description: 'Culinary and medicinal spices and herbs',
      icon: Icons.spa,
      color: Color(0xFFE91E63),
      subcategories: ['Warming Spices', 'Cooling Herbs', 'Aromatic', 'Bitter'],
    ),
    FoodCategory(
      id: 'nuts',
      name: 'Nuts & Seeds',
      description: 'Almonds, walnuts, seeds, and other nuts',
      icon: Icons.park,
      color: Color(0xFF795548),
      subcategories: ['Tree Nuts', 'Seeds', 'Dry Fruits'],
    ),
    FoodCategory(
      id: 'oils',
      name: 'Oils & Fats',
      description: 'Cooking oils, ghee, and healthy fats',
      icon: Icons.opacity,
      color: Color(0xFFFFEB3B),
      subcategories: ['Cooking Oils', 'Essential Oils', 'Animal Fats'],
    ),
  ];
}