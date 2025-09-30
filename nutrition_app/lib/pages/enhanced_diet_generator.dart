import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../models/enhanced_food_models.dart';
import '../data/ayurvedic_food_database.dart';
import '../theme/app_styles.dart';
import '../widgets/food_search_page.dart';

class EnhancedDietGeneratorPage extends StatefulWidget {
  final String patientId;

  const EnhancedDietGeneratorPage({
    Key? key,
    required this.patientId,
  }) : super(key: key);

  @override
  State<EnhancedDietGeneratorPage> createState() => _EnhancedDietGeneratorPageState();
}

class _EnhancedDietGeneratorPageState extends State<EnhancedDietGeneratorPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, List<FoodItem>> _mealPlan = {
    'breakfast': [],
    'lunch': [],
    'dinner': [],
    'snacks': [],
  };
  
  NutritionData _totalNutrition = const NutritionData(
    calories: 0,
    protein: 0,
    carbs: 0,
    fats: 0,
    fiber: 0,
  );

  bool _isGenerating = false;
  PatientProfile? _patient;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadPatient();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadPatient() {
    final notifier = context.read<PatientNotifier>();
    _patient = notifier.patients.firstWhere((p) => p.id == widget.patientId);
  }

  void _calculateTotalNutrition() {
    NutritionData total = const NutritionData(calories: 0, protein: 0, carbs: 0, fats: 0, fiber: 0);
    
    for (final meal in _mealPlan.values) {
      for (final food in meal) {
        total = total.add(food.nutrition);
      }
    }
    
    setState(() {
      _totalNutrition = total;
    });
  }

  void _addFoodToMeal(String mealType, FoodItem food) {
    setState(() {
      _mealPlan[mealType]?.add(food);
    });
    _calculateTotalNutrition();
  }

  void _removeFoodFromMeal(String mealType, int index) {
    setState(() {
      _mealPlan[mealType]?.removeAt(index);
    });
    _calculateTotalNutrition();
  }

  Future<void> _generateAIDietPlan() async {
    if (_patient == null) return;

    setState(() {
      _isGenerating = true;
    });

    // Simulate AI generation with delay
    await Future.delayed(const Duration(seconds: 2));

    // Clear existing plan
    for (final meal in _mealPlan.values) {
      meal.clear();
    }

    // Generate based on patient's prakriti and health conditions
    final doshaRecommendations = _getDoshaRecommendations(_patient!.prakriti);
    
    // Add breakfast items
    _mealPlan['breakfast']?.addAll([
      doshaRecommendations['breakfast']?.first ?? AyurvedicFoodDatabase.getFoodById('rice_basmati')!,
    ]);
    
    // Add lunch items
    _mealPlan['lunch']?.addAll([
      doshaRecommendations['lunch']?.first ?? AyurvedicFoodDatabase.getFoodById('spinach_fresh')!,
      AyurvedicFoodDatabase.getFoodById('rice_basmati')!,
    ]);
    
    // Add dinner items
    _mealPlan['dinner']?.addAll([
      doshaRecommendations['dinner']?.first ?? AyurvedicFoodDatabase.getFoodById('quinoa')!,
    ]);

    _calculateTotalNutrition();

    setState(() {
      _isGenerating = false;
    });

    _showGenerationComplete();
  }

  Map<String, List<FoodItem>> _getDoshaRecommendations(String prakriti) {
    // Simplified dosha-based food recommendations
    final dosha = _parsePrakriti(prakriti);
    final recommendedFoods = AyurvedicFoodDatabase.getFoodsForDosha(dosha);
    
    return {
      'breakfast': recommendedFoods.where((f) => f.category == 'grains' || f.category == 'fruits').take(2).toList(),
      'lunch': recommendedFoods.where((f) => f.category == 'vegetables' || f.category == 'legumes').take(3).toList(),
      'dinner': recommendedFoods.where((f) => f.category == 'vegetables' || f.category == 'grains').take(2).toList(),
    };
  }

  Dosha _parsePrakriti(String prakriti) {
    if (prakriti.toLowerCase().contains('vata')) return Dosha.vata;
    if (prakriti.toLowerCase().contains('pitta')) return Dosha.pitta;
    if (prakriti.toLowerCase().contains('kapha')) return Dosha.kapha;
    return Dosha.vata; // Default
  }

  void _showGenerationComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Diet Plan Generated!'),
        content: const Text('AI has created a personalized Ayurvedic diet plan based on the patient\'s prakriti and health conditions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Great!'),
          ),
        ],
      ),
    );
  }

  void _saveDietPlan() {
    if (_patient == null) return;

    // Save to patient notifier using existing method, which will create a proper diet plan
    final notifier = context.read<PatientNotifier>();
    notifier.generatePlanForPatient(
      patientId: _patient!.id,
      goal: 'General wellness',
      activityLevel: _patient!.lifestyle,
      prakriti: _patient!.prakriti,
    );
    
    Navigator.of(context).pop();
  }

  String _capitalizeMealType(String mealType) {
    return mealType[0].toUpperCase() + mealType.substring(1);
  }

  String _getMealTiming(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return '7:30 AM';
      case 'lunch':
        return '1:00 PM';
      case 'dinner':
        return '7:30 PM';
      case 'snacks':
        return '4:30 PM';
      default:
        return '12:00 PM';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Diet Generator'),
            if (_patient != null)
              Text(
                'For ${_patient!.name} • ${_patient!.prakriti}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Breakfast'),
            Tab(text: 'Lunch'),
            Tab(text: 'Dinner'),
            Tab(text: 'Snacks'),
          ],
        ),
        actions: [
          if (_isGenerating)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.auto_awesome),
              onPressed: _generateAIDietPlan,
              tooltip: 'Generate AI Diet Plan',
            ),
        ],
      ),
      body: Column(
        children: [
          // Nutrition summary
          _buildNutritionSummary(),
          
          // Meal tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMealTab('breakfast'),
                _buildMealTab('lunch'),
                _buildMealTab('dinner'),
                _buildMealTab('snacks'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Clear all meals
                  setState(() {
                    for (final meal in _mealPlan.values) {
                      meal.clear();
                    }
                  });
                  _calculateTotalNutrition();
                },
                child: const Text('Clear All'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _mealPlan.values.any((meal) => meal.isNotEmpty) 
                    ? _saveDietPlan 
                    : null,
                child: const Text('Save Diet Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionSummary() {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.glassSurface(context: context).copyWith(
        gradient: AppGradients.ayurvedicWisdom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Nutrition Overview',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Nutrition cards
          Row(
            children: [
              Flexible(child: _buildNutritionCard(
                'Calories',
                '${_totalNutrition.calories.round()}',
                'kcal',
                Icons.local_fire_department_outlined,
                AppGradients.saffronGlow,
              )),
              const SizedBox(width: AppSpacing.sm),
              Flexible(child: _buildNutritionCard(
                'Protein',
                _totalNutrition.protein.toStringAsFixed(1),
                'g',
                Icons.fitness_center_outlined,
                AppGradients.nutritionProtein,
              )),
              const SizedBox(width: AppSpacing.sm),
              Flexible(child: _buildNutritionCard(
                'Carbs',
                _totalNutrition.carbs.toStringAsFixed(1),
                'g',
                Icons.grain_outlined,
                AppGradients.nutritionCarbs,
              )),
              const SizedBox(width: AppSpacing.sm),
              Flexible(child: _buildNutritionCard(
                'Fats',
                _totalNutrition.fats.toStringAsFixed(1),
                'g',
                Icons.opacity_outlined,
                AppGradients.nutritionFats,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(String label, String value, String unit, IconData icon, Gradient gradient) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '$unit\n$label',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTab(String mealType) {
    final foods = _mealPlan[mealType] ?? [];
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Add food button
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showFoodSelector(mealType),
              icon: const Icon(Icons.add),
              label: Text('Add food to ${mealType.toLowerCase()}'),
            ),
          ),
        ),
        
        // Food list
        Expanded(
          child: foods.isEmpty
              ? _buildEmptyMealState(mealType)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: foods.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    return _buildMealFoodCard(food, mealType, index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyMealState(String mealType) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getMealIcon(mealType),
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No foods added to ${mealType.toLowerCase()}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tap the add button to include foods',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealFoodCard(FoodItem food, String mealType, int index) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Food info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${food.nutrition.calories.round()} kcal • ${food.nutrition.protein.toStringAsFixed(1)}g protein',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  
                  // Ayurvedic properties
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: food.ayurvedicProperties.rasas.take(2).map((rasa) =>
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: rasa.color.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          rasa.displayName,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ],
              ),
            ),
            
            // Remove button
            IconButton(
              onPressed: () => _removeFoodFromMeal(mealType, index),
              icon: Icon(
                Icons.remove_circle_outline,
                color: theme.colorScheme.error,
              ),
              tooltip: 'Remove from meal',
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return Icons.free_breakfast_outlined;
      case 'lunch':
        return Icons.lunch_dining_outlined;
      case 'dinner':
        return Icons.dinner_dining_outlined;
      case 'snacks':
        return Icons.cookie_outlined;
      default:
        return Icons.restaurant_outlined;
    }
  }

  void _showFoodSelector(String mealType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FoodSearchPage(
          isSelectionMode: true,
          onFoodSelected: (food) {
            _addFoodToMeal(mealType, food);
            Navigator.of(context).pop(); // Close food selector
          },
        ),
      ),
    );
  }
}