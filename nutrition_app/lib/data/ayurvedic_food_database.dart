import 'package:flutter/material.dart';
import '../models/enhanced_food_models.dart';

class AyurvedicFoodDatabase {
  static final Map<String, FoodItem> _foods = {};
  
  static void _initializeDatabase() {
    if (_foods.isNotEmpty) return;

    // Sample comprehensive food database with Ayurvedic properties
    _addFood(FoodItem(
      id: 'rice_basmati',
      name: 'Basmati Rice',
      category: 'grains',
      subcategory: 'Rice',
      nutrition: const NutritionData(
        calories: 130,
        protein: 2.7,
        carbs: 28.0,
        fats: 0.3,
        fiber: 0.4,
        iron: 0.8,
        magnesium: 12,
        potassium: 35,
      ),
      ayurvedicProperties: const AyurvedicProperties(
        rasas: [Rasa.sweet],
        virya: Virya.cooling,
        vipaka: Vipaka.sweet,
        gunas: [Guna.light, Guna.smooth, Guna.stable],
        balancingDoshas: [Dosha.pitta, Dosha.vata],
        aggravatingDoshas: [],
        digestibility: DigestibilityLevel.easy,
        healthBenefits: [
          HealthBenefit(
            name: 'Energy Provider',
            description: 'Provides sustained energy and easy digestion',
            icon: Icons.battery_charging_full,
          ),
        ],
      ),
      cuisineTypes: ['Indian', 'Asian'],
      tags: ['staple', 'gluten-free', 'versatile'],
      isVegetarian: true,
      isVegan: true,
      isGlutenFree: true,
      description: 'Aromatic long-grain rice with cooling properties, ideal for Pitta dosha',
    ));

    _addFood(FoodItem(
      id: 'spinach_fresh',
      name: 'Fresh Spinach',
      category: 'vegetables',
      subcategory: 'Leafy Greens',
      nutrition: const NutritionData(
        calories: 23,
        protein: 2.9,
        carbs: 3.6,
        fats: 0.4,
        fiber: 2.2,
        iron: 2.7,
        calcium: 99,
        vitaminC: 28.1,
        folate: 194,
        magnesium: 79,
        potassium: 558,
      ),
      ayurvedicProperties: const AyurvedicProperties(
        rasas: [Rasa.bitter, Rasa.astringent],
        virya: Virya.cooling,
        vipaka: Vipaka.pungent,
        gunas: [Guna.light, Guna.dry, Guna.rough],
        balancingDoshas: [Dosha.pitta, Dosha.kapha],
        aggravatingDoshas: [Dosha.vata],
        digestibility: DigestibilityLevel.moderate,
        healthBenefits: [
          HealthBenefit(
            name: 'Blood Purifier',
            description: 'Rich in iron and helps purify blood',
            icon: Icons.bloodtype,
          ),
          HealthBenefit(
            name: 'Eye Health',
            description: 'Contains lutein and zeaxanthin for eye health',
            icon: Icons.visibility,
          ),
        ],
      ),
      cuisineTypes: ['Indian', 'Mediterranean', 'Global'],
      tags: ['superfood', 'iron-rich', 'antioxidant'],
      isVegetarian: true,
      isVegan: true,
      isGlutenFree: true,
      description: 'Nutrient-dense leafy green with cooling and purifying properties',
    ));

    _addFood(FoodItem(
      id: 'mango_ripe',
      name: 'Ripe Mango',
      category: 'fruits',
      subcategory: 'Tropical',
      nutrition: const NutritionData(
        calories: 60,
        protein: 0.8,
        carbs: 15.0,
        fats: 0.4,
        fiber: 1.6,
        sugar: 13.7,
        vitaminC: 36.4,
        folate: 43,
        potassium: 168,
        magnesium: 10,
      ),
      ayurvedicProperties: const AyurvedicProperties(
        rasas: [Rasa.sweet, Rasa.sour],
        virya: Virya.heating,
        vipaka: Vipaka.sweet,
        gunas: [Guna.heavy, Guna.oily, Guna.smooth],
        balancingDoshas: [Dosha.vata],
        aggravatingDoshas: [Dosha.pitta, Dosha.kapha],
        digestibility: DigestibilityLevel.easy,
        healthBenefits: [
          HealthBenefit(
            name: 'Immunity Booster',
            description: 'High in vitamin C and antioxidants',
            icon: Icons.shield,
          ),
          HealthBenefit(
            name: 'Digestive Health',
            description: 'Contains enzymes that aid digestion',
            icon: Icons.healing,
          ),
        ],
      ),
      cuisineTypes: ['Indian', 'Tropical', 'Global'],
      tags: ['seasonal', 'vitamin-c', 'tropical'],
      isVegetarian: true,
      isVegan: true,
      isGlutenFree: true,
      description: 'King of fruits with sweet taste and heating energy',
    ));

    _addFood(FoodItem(
      id: 'turmeric_powder',
      name: 'Turmeric Powder',
      category: 'spices',
      subcategory: 'Warming Spices',
      nutrition: const NutritionData(
        calories: 354,
        protein: 7.8,
        carbs: 64.9,
        fats: 9.9,
        fiber: 21.1,
        iron: 41.4,
        calcium: 183,
        magnesium: 193,
        potassium: 2525,
      ),
      ayurvedicProperties: const AyurvedicProperties(
        rasas: [Rasa.bitter, Rasa.pungent],
        virya: Virya.heating,
        vipaka: Vipaka.pungent,
        gunas: [Guna.light, Guna.dry, Guna.rough],
        balancingDoshas: [Dosha.kapha, Dosha.vata],
        aggravatingDoshas: [Dosha.pitta],
        digestibility: DigestibilityLevel.moderate,
        healthBenefits: [
          HealthBenefit(
            name: 'Anti-inflammatory',
            description: 'Powerful anti-inflammatory and healing properties',
            icon: Icons.healing,
          ),
          HealthBenefit(
            name: 'Liver Support',
            description: 'Supports liver function and detoxification',
            icon: Icons.local_hospital,
          ),
          HealthBenefit(
            name: 'Digestive Aid',
            description: 'Enhances digestion and metabolism',
            icon: Icons.restaurant,
          ),
        ],
      ),
      cuisineTypes: ['Indian', 'Southeast Asian'],
      tags: ['medicinal', 'anti-inflammatory', 'golden-spice'],
      isVegetarian: true,
      isVegan: true,
      isGlutenFree: true,
      description: 'Golden spice with powerful healing and anti-inflammatory properties',
    ));

    _addFood(FoodItem(
      id: 'almonds_raw',
      name: 'Raw Almonds',
      category: 'nuts',
      subcategory: 'Tree Nuts',
      nutrition: const NutritionData(
        calories: 579,
        protein: 21.2,
        carbs: 21.6,
        fats: 49.9,
        fiber: 12.5,
        calcium: 269,
        iron: 3.7,
        magnesium: 270,
        potassium: 733,
        omega3: 0.006,
      ),
      ayurvedicProperties: const AyurvedicProperties(
        rasas: [Rasa.sweet],
        virya: Virya.heating,
        vipaka: Vipaka.sweet,
        gunas: [Guna.heavy, Guna.oily, Guna.smooth],
        balancingDoshas: [Dosha.vata],
        aggravatingDoshas: [Dosha.pitta, Dosha.kapha],
        digestibility: DigestibilityLevel.moderate,
        healthBenefits: [
          HealthBenefit(
            name: 'Brain Health',
            description: 'Rich in healthy fats that support brain function',
            icon: Icons.psychology,
          ),
          HealthBenefit(
            name: 'Heart Health',
            description: 'Contains monounsaturated fats good for heart',
            icon: Icons.favorite,
          ),
          HealthBenefit(
            name: 'Bone Strength',
            description: 'High in calcium and magnesium for bone health',
            icon: Icons.sports_martial_arts,
          ),
        ],
      ),
      cuisineTypes: ['Indian', 'Mediterranean', 'Global'],
      tags: ['protein-rich', 'healthy-fats', 'brain-food'],
      isVegetarian: true,
      isVegan: true,
      isGlutenFree: true,
      description: 'Nutrient-dense nuts that nourish the nervous system and provide sustained energy',
    ));

    _addFood(FoodItem(
      id: 'ghee_cow',
      name: 'Cow Ghee',
      category: 'oils',
      subcategory: 'Animal Fats',
      nutrition: const NutritionData(
        calories: 900,   
        protein: 0.0,
        carbs: 0.0,
        fats: 100.0,
        fiber: 0.0,
        saturatedFat: 62.0,
        cholesterol: 256,
      ),
      ayurvedicProperties: const AyurvedicProperties(
        rasas: [Rasa.sweet],
        virya: Virya.heating,
        vipaka: Vipaka.sweet,
        gunas: [Guna.heavy, Guna.oily, Guna.smooth],
        balancingDoshas: [Dosha.vata, Dosha.pitta],
        aggravatingDoshas: [Dosha.kapha],
        digestibility: DigestibilityLevel.easy,
        healthBenefits: [
          HealthBenefit(
            name: 'Digestive Fire',
            description: 'Enhances digestive fire and absorption',
            icon: Icons.local_fire_department,
          ),
          HealthBenefit(
            name: 'Mental Clarity',
            description: 'Nourishes the brain and enhances memory',
            icon: Icons.lightbulb,
          ),
          HealthBenefit(
            name: 'Ojas Builder',
            description: 'Builds vital essence and immunity',
            icon: Icons.shield,
          ),
        ],
      ),
      cuisineTypes: ['Indian', 'Ayurvedic'],
      tags: ['sacred-food', 'digestive-aid', 'brain-tonic'],
      isVegetarian: true,
      isVegan: false,
      isGlutenFree: true,
      description: 'Sacred clarified butter that enhances digestion and nourishes all tissues',
    ));

    // Add more foods to reach 8000+ items (abbreviated for demo)
    _addBulkFoods();
  }

  static void _addFood(FoodItem food) {
    _foods[food.id] = food;
  }

  static void _addBulkFoods() {
    // This would contain the full 8000+ food database
    // For demo purposes, adding a few more essential items
    
    final bulkFoods = [
      // More grains
      _createQuickFood('quinoa', 'Quinoa', 'grains', 'Quinoa', 
        NutritionData(calories: 120, protein: 4.4, carbs: 22.0, fats: 1.9, fiber: 2.8),
        [Rasa.sweet], Virya.heating, [Dosha.vata]),
      
      // More vegetables  
      _createQuickFood('broccoli', 'Broccoli', 'vegetables', 'Cruciferous',
        NutritionData(calories: 34, protein: 2.8, carbs: 7.0, fats: 0.4, fiber: 2.6),
        [Rasa.bitter, Rasa.astringent], Virya.cooling, [Dosha.pitta, Dosha.kapha]),
      
      // More fruits
      _createQuickFood('apple', 'Apple', 'fruits', 'Temperate',
        NutritionData(calories: 52, protein: 0.3, carbs: 14.0, fats: 0.2, fiber: 2.4),
        [Rasa.sweet, Rasa.astringent], Virya.cooling, [Dosha.pitta]),
      
      // More legumes
      _createQuickFood('chickpeas', 'Chickpeas', 'legumes', 'Beans',
        NutritionData(calories: 164, protein: 8.9, carbs: 27.4, fats: 2.6, fiber: 7.6),
        [Rasa.sweet, Rasa.astringent], Virya.heating, [Dosha.vata]),
      
      // More spices
      _createQuickFood('ginger', 'Fresh Ginger', 'spices', 'Warming Spices',
        NutritionData(calories: 80, protein: 1.8, carbs: 18.0, fats: 0.8, fiber: 2.0),
        [Rasa.pungent, Rasa.sweet], Virya.heating, [Dosha.vata, Dosha.kapha]),
    ];

    for (final food in bulkFoods) {
      _addFood(food);
    }
  }

  static FoodItem _createQuickFood(
    String id,
    String name,
    String category,
    String subcategory,
    NutritionData nutrition,
    List<Rasa> rasas,
    Virya virya,
    List<Dosha> balancingDoshas,
  ) {
    return FoodItem(
      id: id,
      name: name,
      category: category,
      subcategory: subcategory,
      nutrition: nutrition,
      ayurvedicProperties: AyurvedicProperties(
        rasas: rasas,
        virya: virya,
        vipaka: Vipaka.sweet, // Default
        gunas: [Guna.light], // Default
        balancingDoshas: balancingDoshas,
        aggravatingDoshas: [],
        digestibility: DigestibilityLevel.moderate,
      ),
      isVegetarian: true,
      isVegan: category != 'dairy',
      isGlutenFree: true,
    );
  }

  // Public API methods
  static List<FoodItem> get allFoods {
    _initializeDatabase();
    return _foods.values.toList();
  }

  static FoodItem? getFoodById(String id) {
    _initializeDatabase();
    return _foods[id];
  }

  static List<FoodItem> getFoodsByCategory(String category) {
    _initializeDatabase();
    return _foods.values.where((food) => food.category == category).toList();
  }

  static List<FoodItem> searchFoods(String query) {
    _initializeDatabase();
    final searchTerm = query.toLowerCase();
    return _foods.values.where((food) {
      return food.name.toLowerCase().contains(searchTerm) ||
             food.category.toLowerCase().contains(searchTerm) ||
             food.tags.any((tag) => tag.toLowerCase().contains(searchTerm)) ||
             food.alternativeNames.any((name) => name.toLowerCase().contains(searchTerm));
    }).toList();
  }

  static List<FoodItem> getFoodsForDosha(Dosha dosha) {
    _initializeDatabase();
    return _foods.values.where((food) => 
      food.ayurvedicProperties.balancingDoshas.contains(dosha) &&
      !food.ayurvedicProperties.aggravatingDoshas.contains(dosha)
    ).toList();
  }

  static List<FoodItem> getFoodsByRasa(Rasa rasa) {
    _initializeDatabase();
    return _foods.values.where((food) => 
      food.ayurvedicProperties.rasas.contains(rasa)
    ).toList();
  }

  static List<FoodItem> getFoodsByVirya(Virya virya) {
    _initializeDatabase();
    return _foods.values.where((food) => 
      food.ayurvedicProperties.virya == virya
    ).toList();
  }

  static List<FoodItem> getHighProteinFoods({double minProtein = 10.0}) {
    _initializeDatabase();
    return _foods.values.where((food) => 
      food.nutrition.protein >= minProtein
    ).toList();
  }

  static List<FoodItem> getLowCalorieFoods({double maxCalories = 100.0}) {
    _initializeDatabase();
    return _foods.values.where((food) => 
      food.nutrition.calories <= maxCalories
    ).toList();
  }

  static List<FoodItem> getVeganFoods() {
    _initializeDatabase();
    return _foods.values.where((food) => food.isVegan).toList();
  }

  static List<FoodItem> getGlutenFreeFoods() {
    _initializeDatabase();
    return _foods.values.where((food) => food.isGlutenFree).toList();
  }

  static Map<String, int> getCategoryStats() {
    _initializeDatabase();
    final stats = <String, int>{};
    for (final food in _foods.values) {
      stats[food.category] = (stats[food.category] ?? 0) + 1;
    }
    return stats;
  }

  static int get totalFoodCount {
    _initializeDatabase();
    return _foods.length;
  }
}