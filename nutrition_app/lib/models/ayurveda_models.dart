import 'dart:math';

class NutritionalBreakdown {
  final int calories;
  final int protein;
  final int carbs;
  final int fats;

  const NutritionalBreakdown({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  const NutritionalBreakdown.zero()
      : calories = 0,
        protein = 0,
        carbs = 0,
        fats = 0;

  NutritionalBreakdown operator +(NutritionalBreakdown other) {
    return NutritionalBreakdown(
      calories: calories + other.calories,
      protein: protein + other.protein,
      carbs: carbs + other.carbs,
      fats: fats + other.fats,
    );
  }
}

class MealOption {
  final String name;
  final NutritionalBreakdown nutrition;
  final List<String> ayurvedicTags;
  final List<String> rasaProfiles;
  final List<String> ingredients;
  final String notes;

  const MealOption({
    required this.name,
    required this.nutrition,
    required this.ayurvedicTags,
    required this.rasaProfiles,
    required this.ingredients,
    required this.notes,
  });
}

class DietMeal {
  final String slot;
  final String timing;
  final List<MealOption> options;
  final int selectedIndex;
  final String? guidance;

  const DietMeal({
    required this.slot,
    required this.timing,
    required this.options,
    this.selectedIndex = 0,
    this.guidance,
  }) : assert(options.length > 0, 'Each meal needs at least one option');

  MealOption get currentOption => options[selectedIndex];

  DietMeal copyWith({
    List<MealOption>? options,
    int? selectedIndex,
    String? guidance,
  }) {
    return DietMeal(
      slot: slot,
      timing: timing,
      options: options ?? this.options,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      guidance: guidance ?? this.guidance,
    );
  }

  DietMeal advanceOption() {
    if (options.isEmpty) {
      return this;
    }
    final nextIndex = (selectedIndex + 1) % options.length;
    return copyWith(selectedIndex: nextIndex);
  }
}

class DietPlan {
  final String id;
  final String patientId;
  final String patientName;
  final String prakriti;
  final String goal;
  final String activityLevel;
  final String summary;
  final DateTime generatedAt;
  final List<DietMeal> meals;

  const DietPlan({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.prakriti,
    required this.goal,
    required this.activityLevel,
    required this.summary,
    required this.generatedAt,
    required this.meals,
  });

  DietPlan copyWith({
    String? summary,
    List<DietMeal>? meals,
  }) {
    return DietPlan(
      id: id,
      patientId: patientId,
      patientName: patientName,
      prakriti: prakriti,
      goal: goal,
      activityLevel: activityLevel,
      summary: summary ?? this.summary,
      generatedAt: generatedAt,
      meals: meals ?? this.meals,
    );
  }

  NutritionalBreakdown get totalNutrition {
    return meals.fold(
      const NutritionalBreakdown.zero(),
      (acc, meal) => acc + meal.currentOption.nutrition,
    );
  }
}

class PatientProfile {
  final String id;
  final String name;
  final int age;
  final String gender;
  final double weight;
  final String lifestyle;
  final String prakriti;
  final String digestionQuality;
  final String bowelMovements;
  final String waterIntake;
  final List<String> healthTags;
  final List<String> focusAreas;
  final String? notes;

  const PatientProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.lifestyle,
    required this.prakriti,
    required this.digestionQuality,
    required this.bowelMovements,
    required this.waterIntake,
    required this.healthTags,
    required this.focusAreas,
    this.notes,
  });
}

class AyurvedaDietTemplates {
  static DietPlan buildPlan({
    required PatientProfile patient,
    required String goal,
    required String activityLevel,
    required String prakriti,
  }) {
    final normalizedPrakriti =
        prakriti.trim().isEmpty ? patient.prakriti : prakriti;
    final meals = _mealsForPrakriti(normalizedPrakriti).map((meal) {
      final selectedIndex = _initialIndexForGoal(goal, meal.options.length);
      return meal.copyWith(selectedIndex: selectedIndex);
    }).toList();

    final summary = _buildSummary(
      patient: patient,
      goal: goal,
      activityLevel: activityLevel,
      prakriti: normalizedPrakriti,
      meals: meals,
    );

    return DietPlan(
      id: 'plan_${patient.id}_${DateTime.now().millisecondsSinceEpoch}',
      patientId: patient.id,
      patientName: patient.name,
      prakriti: normalizedPrakriti,
      goal: goal,
      activityLevel: activityLevel,
      summary: summary,
      generatedAt: DateTime.now(),
      meals: meals,
    );
  }

  static List<DietMeal> _mealsForPrakriti(String prakriti) {
    switch (prakriti.toLowerCase()) {
      case 'vata':
        return _vataMeals();
      case 'pitta':
        return _pittaMeals();
      case 'kapha':
        return _kaphaMeals();
      default:
        return _pittaMeals();
    }
  }

  static String _buildSummary({
    required PatientProfile patient,
    required String goal,
    required String activityLevel,
    required String prakriti,
    required List<DietMeal> meals,
  }) {
    final nutrition = meals.fold(
      const NutritionalBreakdown.zero(),
      (acc, meal) => acc + meal.currentOption.nutrition,
    );

    final tones = {
      'vata': 'grounding & nourishing',
      'pitta': 'cooling & soothing',
      'kapha': 'light & invigorating',
    };

    final focus = tones[prakriti.toLowerCase()] ?? 'balanced';

    return '${patient.name}\'s ${goal.toLowerCase()} plan emphasises $focus choices with approximately '
        '${nutrition.calories} kcal to suit a ${activityLevel.toLowerCase()} lifestyle.';
  }

  static int _initialIndexForGoal(String goal, int optionsLength) {
    if (optionsLength <= 1) return 0;
    final normalized = goal.toLowerCase();
    if (normalized.contains('gain')) {
      return min(1, optionsLength - 1);
    }
    return 0;
  }

  static List<DietMeal> _vataMeals() {
    return [
      DietMeal(
        slot: 'Breakfast',
        timing: '7:30 AM',
        guidance: 'Begin with warm ginger-jaggery water to kindle Agni gently.',
        options: [
          MealOption(
            name: 'Ragi Porridge with Stewed Pear',
            nutrition: const NutritionalBreakdown(
                calories: 320, protein: 12, carbs: 52, fats: 8),
            ayurvedicTags: const ['Warm', 'Grounding', 'Easy to digest'],
            rasaProfiles: const ['Madhura (Sweet)', 'Kashaya (Astringent)'],
            ingredients: const [
              '1/2 cup sprouted ragi flour',
              '1 cup oat milk',
              '1 stewed pear with cardamom',
              '1 tsp ghee',
              'Nutmeg & ginger',
            ],
            notes:
                'Balances Vata through warmth and unctuousness while providing sustained energy.',
          ),
          MealOption(
            name: 'Moong Dal Pancakes with Sesame Chutney',
            nutrition: const NutritionalBreakdown(
                calories: 350, protein: 18, carbs: 45, fats: 9),
            ayurvedicTags: const ['Protein-rich', 'Stabilising', 'Warm Virya'],
            rasaProfiles: const ['Madhura (Sweet)', 'Lavana (Salty)'],
            ingredients: const [
              'Moong dal batter',
              'Black sesame chutney',
              'Curry leaves tempering',
              'Ajwain (carom) seeds',
            ],
            notes:
                'Fermented batter is airy yet grounding; sesame offers lubrication for dry Vata.',
          ),
        ],
      ),
      DietMeal(
        slot: 'Lunch',
        timing: '1:00 PM',
        guidance:
            'Encourage mid-day sunshine and mindful chewing to support absorption.',
        options: [
          MealOption(
            name: 'Khichdi Bowl with Pumpkin & Ghee',
            nutrition: const NutritionalBreakdown(
                calories: 480, protein: 16, carbs: 68, fats: 14),
            ayurvedicTags: const ['Satmya', 'Snehana', 'Gut-soothing'],
            rasaProfiles: const ['Madhura (Sweet)', 'Kashaya (Astringent)'],
            ingredients: const [
              'Moong dal & rice khichdi',
              'Steamed pumpkin with cumin',
              'Homemade ghee',
              'Coriander-lime salad',
            ],
            notes:
                'Classic Vata pacifying combo with mild spices and adequate oiliness.',
          ),
          MealOption(
            name: 'Quinoa Upma with Paneer Cubes',
            nutrition: const NutritionalBreakdown(
                calories: 510, protein: 22, carbs: 60, fats: 16),
            ayurvedicTags: const [
              'Warm Virya',
              'Spiced lightly',
              'Protein enriched'
            ],
            rasaProfiles: const ['Madhura (Sweet)', 'Katu (Pungent)'],
            ingredients: const [
              'Tri-colour quinoa',
              'Homemade paneer cubes',
              'Cashews & curry leaves',
              'Mustard seed tempering',
            ],
            notes:
                'Adds variety while maintaining warmth and a soft texture that Vata tolerates.',
          ),
        ],
      ),
      DietMeal(
        slot: 'Snack',
        timing: '4:30 PM',
        guidance:
            'Offer herbal tea with ashwagandha or licorice for nervous system support.',
        options: [
          MealOption(
            name: 'Date & Almond Laddoos',
            nutrition: const NutritionalBreakdown(
                calories: 190, protein: 5, carbs: 24, fats: 8),
            ayurvedicTags: const ['Ojas building', 'Sweet Rasa', 'Nourishing'],
            rasaProfiles: const ['Madhura (Sweet)'],
            ingredients: const [
              'Soft dates',
              'Blanched almonds',
              'Desiccated coconut',
              'Cardamom powder',
            ],
            notes:
                'Great for afternoon crashes; balances anxiety with natural sweetness.',
          ),
          MealOption(
            name: 'Warm Saffron Almond Milk',
            nutrition: const NutritionalBreakdown(
                calories: 160, protein: 6, carbs: 18, fats: 7),
            ayurvedicTags: const ['Warm', 'Rejuvenating', 'Tridoshic'],
            rasaProfiles: const ['Madhura (Sweet)'],
            ingredients: const [
              'Homemade almond milk',
              'Saffron strands',
              'Jaggery',
              'A pinch of turmeric',
            ],
            notes:
                'Liquid nourishment to ground Vata while preparing for a lighter dinner.',
          ),
        ],
      ),
      DietMeal(
        slot: 'Dinner',
        timing: '7:30 PM',
        guidance:
            'Recommend light stretching and gratitude journaling before bed.',
        options: [
          MealOption(
            name: 'Vegetable Stew with Millet Rotis',
            nutrition: const NutritionalBreakdown(
                calories: 420, protein: 14, carbs: 58, fats: 12),
            ayurvedicTags: const [
              'Light-yet-warm',
              'Digestive',
              'Contains ghee'
            ],
            rasaProfiles: const ['Madhura (Sweet)', 'Tikta (Bitter)'],
            ingredients: const [
              'Seasonal root vegetables',
              'Coconut milk base',
              'Little millet rotis',
              'Herbal ghee drizzle',
            ],
            notes:
                'Balances nourishment with an easy-to-digest texture for sound sleep.',
          ),
          MealOption(
            name: 'Moong Soup with Spinach & Fennel',
            nutrition: const NutritionalBreakdown(
                calories: 360, protein: 20, carbs: 46, fats: 9),
            ayurvedicTags: const ['Sattvic', 'Calming', 'High protein'],
            rasaProfiles: const ['Madhura (Sweet)', 'Tikta (Bitter)'],
            ingredients: const [
              'Split green gram',
              'Spinach leaves',
              'Fennel & cumin tempering',
              'Lemon zest',
            ],
            notes:
                'Fennel helps reduce bloating; soup format is Vata friendly.',
          ),
        ],
      ),
    ];
  }

  static List<DietMeal> _pittaMeals() {
    return [
      DietMeal(
        slot: 'Breakfast',
        timing: '7:15 AM',
        guidance:
            'Start with room-temperature aloe vera juice diluted with water.',
        options: [
          MealOption(
            name: 'Cooling Coconut-Chia Parfait',
            nutrition: const NutritionalBreakdown(
                calories: 310, protein: 10, carbs: 42, fats: 12),
            ayurvedicTags: const ['Cooling', 'Anti-inflammatory', 'Hydrating'],
            rasaProfiles: const ['Madhura (Sweet)', 'Tikta (Bitter)'],
            ingredients: const [
              'Tender coconut flesh',
              'Unsweetened coconut milk',
              'Soaked chia seeds',
              'Dragon fruit & pomegranate',
            ],
            notes:
                'Soothes excess heat while still providing fibre and satiety.',
          ),
          MealOption(
            name: 'Pearl Millet Idli with Cilantro Chutney',
            nutrition: const NutritionalBreakdown(
                calories: 330, protein: 14, carbs: 50, fats: 6),
            ayurvedicTags: const ['Tridoshic', 'Mild spice', 'Low oil'],
            rasaProfiles: const ['Madhura (Sweet)', 'Kashaya (Astringent)'],
            ingredients: const [
              'Bajra idli batter',
              'Coconut & cilantro chutney',
              'Roasted cumin powder',
            ],
            notes:
                'Fermented batter is gentle on Pitta while pearl millet keeps blood sugar steady.',
          ),
        ],
      ),
      DietMeal(
        slot: 'Lunch',
        timing: '12:45 PM',
        guidance:
            'Recommend a short mindful breathing break before meals to cool the system.',
        options: [
          MealOption(
            name: 'Red Rice Buddha Bowl',
            nutrition: const NutritionalBreakdown(
                calories: 470, protein: 18, carbs: 62, fats: 14),
            ayurvedicTags: const [
              'Cooling Virya',
              'Digestive bitters',
              'Anti-acidic'
            ],
            rasaProfiles: const [
              'Tikta (Bitter)',
              'Madhura (Sweet)',
              'Kashaya (Astringent)'
            ],
            ingredients: const [
              'Red rice',
              'Steamed asparagus & broccoli',
              'Sesame tofu cubes',
              'Coconut-mint dressing',
            ],
            notes:
                'Balances heat with bitter greens while keeping protein adequate.',
          ),
          MealOption(
            name: 'Barley & Moringa Dal',
            nutrition: const NutritionalBreakdown(
                calories: 440, protein: 20, carbs: 58, fats: 10),
            ayurvedicTags: const ['Cooling', 'Liver supportive', 'Light'],
            rasaProfiles: const ['Tikta (Bitter)', 'Kashaya (Astringent)'],
            ingredients: const [
              'Pearled barley',
              'Yellow mung dal',
              'Moringa leaves',
              'Coriander-coconut chutney',
            ],
            notes:
                'Excellent for inflammatory conditions and supports detox pathways.',
          ),
        ],
      ),
      DietMeal(
        slot: 'Snack',
        timing: '5:00 PM',
        guidance:
            'Infuse water with mint & fennel; encourage digital sunset to reduce heat.',
        options: [
          MealOption(
            name: 'Cucumber & Amla Sherbet',
            nutrition: const NutritionalBreakdown(
                calories: 120, protein: 2, carbs: 26, fats: 2),
            ayurvedicTags: const [
              'Pitta pacifying',
              'Vitamin C rich',
              'Rehydrating'
            ],
            rasaProfiles: const ['Amla (Sour)', 'Madhura (Sweet)'],
            ingredients: const [
              'Blended cucumber',
              'Amla juice',
              'Tulsi leaves',
              'Rock sugar (mishri)',
            ],
            notes: 'Quickly cools while supporting digestion and immunity.',
          ),
          MealOption(
            name: 'Lotus Seed Trail Mix',
            nutrition: const NutritionalBreakdown(
                calories: 180, protein: 6, carbs: 20, fats: 8),
            ayurvedicTags: const [
              'Neutral Virya',
              'Crunchy',
              'Travel friendly'
            ],
            rasaProfiles: const ['Madhura (Sweet)', 'Kashaya (Astringent)'],
            ingredients: const [
              'Roasted makhana',
              'Pumpkin seeds',
              'Dried rose petals',
              'Coated with gulkand dust',
            ],
            notes: 'Light yet satisfying; rose petals calm the mind.',
          ),
        ],
      ),
      DietMeal(
        slot: 'Dinner',
        timing: '7:15 PM',
        guidance:
            'Advise moon-lit walk post dinner for additional cooling effect.',
        options: [
          MealOption(
            name: 'Carrot & Coconut Stew with Red Lentils',
            nutrition: const NutritionalBreakdown(
                calories: 380, protein: 18, carbs: 46, fats: 12),
            ayurvedicTags: const ['Cooling spices', 'Comforting', 'High fibre'],
            rasaProfiles: const ['Madhura (Sweet)', 'Tikta (Bitter)'],
            ingredients: const [
              'Red lentils',
              'Coconut milk',
              'Carrots & zucchini',
              'Coriander & fennel seeds',
            ],
            notes:
                'Moderate protein with soothing fats keeps Pitta calm overnight.',
          ),
          MealOption(
            name: 'Herbed Quinoa & Lauki Boats',
            nutrition: const NutritionalBreakdown(
                calories: 360, protein: 16, carbs: 44, fats: 9),
            ayurvedicTags: const ['Light dinner', 'Mild spices', 'Diuretic'],
            rasaProfiles: const ['Tikta (Bitter)', 'Kashaya (Astringent)'],
            ingredients: const [
              'Bottle gourd halves',
              'Stuffed with quinoa & peas',
              'Mint-cilantro pesto',
              'Roasted sunflower seeds',
            ],
            notes:
                'Helps with water retention and keeps night-time heat in check.',
          ),
        ],
      ),
    ];
  }

  static List<DietMeal> _kaphaMeals() {
    return [
      DietMeal(
        slot: 'Breakfast',
        timing: '7:45 AM',
        guidance: 'Recommend dry brushing and a brisk walk before this meal.',
        options: [
          MealOption(
            name: 'Spiced Amaranth Porridge',
            nutrition: const NutritionalBreakdown(
                calories: 300, protein: 11, carbs: 48, fats: 7),
            ayurvedicTags: const [
              'Light',
              'Metabolism boosting',
              'Stimulating'
            ],
            rasaProfiles: const ['Katu (Pungent)', 'Tikta (Bitter)'],
            ingredients: const [
              'Amaranth seeds',
              'Cinnamon & black pepper',
              'Stewed apple slices',
              'Flaxseed topping',
            ],
            notes:
                'Warming spices ignite Kapha digestion without excess heaviness.',
          ),
          MealOption(
            name: 'Sprouted Moong Salad Jar',
            nutrition: const NutritionalBreakdown(
                calories: 280, protein: 16, carbs: 36, fats: 6),
            ayurvedicTags: const [
              'Dry light texture',
              'Enzyme rich',
              'Kapha pacifying'
            ],
            rasaProfiles: const ['Katu (Pungent)', 'Kashaya (Astringent)'],
            ingredients: const [
              'Sprouted mung beans',
              'Grated radish & carrot',
              'Lemon-ginger dressing',
              'Roasted peanuts',
            ],
            notes: 'Crunchy salad keeps Kapha alert through the morning.',
          ),
        ],
      ),
      DietMeal(
        slot: 'Lunch',
        timing: '1:15 PM',
        guidance:
            'Encourage largest meal at lunch with bitter greens to cut through lethargy.',
        options: [
          MealOption(
            name: 'Millet Kadhi with Saag Quinoa',
            nutrition: const NutritionalBreakdown(
                calories: 430, protein: 20, carbs: 58, fats: 12),
            ayurvedicTags: const [
              'Heating spices',
              'Gut cleansing',
              'High protein'
            ],
            rasaProfiles: const ['Katu (Pungent)', 'Tikta (Bitter)'],
            ingredients: const [
              'Probiotic buttermilk kadhi',
              'Finger millet dumplings',
              'Quinoa tossed with mustard greens',
            ],
            notes:
                'Combines probiotics with light grains to balance heaviness.',
          ),
          MealOption(
            name: 'Vegetable Saute with Horse Gram Crepes',
            nutrition: const NutritionalBreakdown(
                calories: 450, protein: 24, carbs: 54, fats: 10),
            ayurvedicTags: const ['Kapha reducing', 'Dry heat', 'High fibre'],
            rasaProfiles: const ['Tikta (Bitter)', 'Kashaya (Astringent)'],
            ingredients: const [
              'Horse gram cheelas',
              'Sauteed gourds & beans',
              'Tulsi chutney',
            ],
            notes:
                'Horse gram is excellent for Kapha stagnation and weight management.',
          ),
        ],
      ),
      DietMeal(
        slot: 'Snack',
        timing: '5:30 PM',
        guidance:
            'Swap evening tea for trikatu-infused lime water to clear channels.',
        options: [
          MealOption(
            name: 'Roasted Chickpea Chaat',
            nutrition: const NutritionalBreakdown(
                calories: 160, protein: 8, carbs: 22, fats: 4),
            ayurvedicTags: const [
              'Dry texture',
              'Heating spice blend',
              'Kapha pacifying'
            ],
            rasaProfiles: const ['Katu (Pungent)', 'Amla (Sour)'],
            ingredients: const [
              'Roasted chickpeas',
              'Raw mango powder',
              'Mint & coriander',
              'Black salt',
            ],
            notes: 'Excellent to curb cravings without adding heaviness.',
          ),
          MealOption(
            name: 'Herbal Spice Latte (Caffeine-free)',
            nutrition: const NutritionalBreakdown(
                calories: 140, protein: 5, carbs: 18, fats: 5),
            ayurvedicTags: const ['Thermogenic', 'Digestive', 'Sattvic'],
            rasaProfiles: const ['Katu (Pungent)', 'Tikta (Bitter)'],
            ingredients: const [
              'Turmeric',
              'Dry ginger',
              'Clove & cinnamon',
              'Oat milk',
            ],
            notes: 'Warms the system and keeps Kapha mucus in check.',
          ),
        ],
      ),
      DietMeal(
        slot: 'Dinner',
        timing: '7:45 PM',
        guidance:
            'Encourage light dinner before 8 PM and a short pranayama session.',
        options: [
          MealOption(
            name: 'Steamed Lotus Stem & Lentil Soup',
            nutrition: const NutritionalBreakdown(
                calories: 340, protein: 22, carbs: 40, fats: 8),
            ayurvedicTags: const [
              'Light dinner',
              'Kapha reducing',
              'Diuretic support'
            ],
            rasaProfiles: const ['Tikta (Bitter)', 'Kashaya (Astringent)'],
            ingredients: const [
              'Lotus stem slices',
              'Masoor dal',
              'Black pepper & cumin',
              'Parsley garnish',
            ],
            notes:
                'Lotus stem adds crunch while keeping meal light and channel-clearing.',
          ),
          MealOption(
            name: 'Stuffed Capsicum with Foxtail Millet',
            nutrition: const NutritionalBreakdown(
                calories: 360, protein: 18, carbs: 48, fats: 9),
            ayurvedicTags: const [
              'Stimulating',
              'Sattvic spices',
              'High fibre'
            ],
            rasaProfiles: const ['Katu (Pungent)', 'Tikta (Bitter)'],
            ingredients: const [
              'Capsicums baked',
              'Foxtail millet pilaf',
              'Kasuri methi & ajwain',
              'Toasted seeds topping',
            ],
            notes:
                'Adds heat and crunch, supporting Kapha metabolism without heaviness.',
          ),
        ],
      ),
    ];
  }
}
