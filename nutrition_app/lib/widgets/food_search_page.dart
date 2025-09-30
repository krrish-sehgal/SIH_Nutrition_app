import 'package:flutter/material.dart';
import '../models/enhanced_food_models.dart';
import '../data/ayurvedic_food_database.dart';
import '../theme/app_styles.dart';

class FoodSearchPage extends StatefulWidget {
  final Function(FoodItem)? onFoodSelected;
  final bool isSelectionMode;

  const FoodSearchPage({
    Key? key,
    this.onFoodSelected,
    this.isSelectionMode = false,
  }) : super(key: key);

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<FoodItem> _filteredFoods = [];
  List<FoodItem> _allFoods = [];
  String _selectedCategory = 'all';
  Dosha? _selectedDosha;
  Rasa? _selectedRasa;
  bool _showFilters = false;
  
  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;

  @override
  void initState() {
    super.initState();
    _allFoods = AyurvedicFoodDatabase.allFoods;
    _filteredFoods = _allFoods;
    
    _filterAnimationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: AppAnimations.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  void _filterFoods() {
    setState(() {
      _filteredFoods = _allFoods.where((food) {
        final matchesSearch = _searchController.text.isEmpty ||
            food.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            food.category.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            food.tags.any((tag) => tag.toLowerCase().contains(_searchController.text.toLowerCase()));

        final matchesCategory = _selectedCategory == 'all' ||
            food.category == _selectedCategory;

        final matchesDosha = _selectedDosha == null ||
            food.ayurvedicProperties.balancingDoshas.contains(_selectedDosha!);

        final matchesRasa = _selectedRasa == null ||
            food.ayurvedicProperties.rasas.contains(_selectedRasa!);

        return matchesSearch && matchesCategory && matchesDosha && matchesRasa;
      }).toList();
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
    if (_showFilters) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'all';
      _selectedDosha = null;
      _selectedRasa = null;
      _searchController.clear();
    });
    _filterFoods();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Food Database'),
            Text(
              '${_filteredFoods.length} of ${_allFoods.length} foods',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            onPressed: _toggleFilters,
            tooltip: _showFilters ? 'Hide filters' : 'Show filters',
          ),
          if (_showFilters)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearFilters,
              tooltip: 'Clear filters',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search foods, categories, or properties...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterFoods();
                        },
                      )
                    : null,
              ),
              onChanged: (_) => _filterFoods(),
            ),
          ),
          
          // Filters section
          AnimatedBuilder(
            animation: _filterAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _filterAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      Text(
                        'Filters',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      
                      // Category filter
                      _buildCategoryFilter(),
                      const SizedBox(height: AppSpacing.md),
                      
                      // Dosha filter
                      _buildDoshaFilter(),
                      const SizedBox(height: AppSpacing.md),
                      
                      // Rasa filter
                      _buildRasaFilter(),
                      const Divider(),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Results
          Expanded(
            child: _filteredFoods.isEmpty
                ? _buildEmptyState()
                : _buildFoodList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['all', ...FoodCategories.all.map((c) => c.id)];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category'),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: categories.map((category) {
            final isSelected = _selectedCategory == category;
            final categoryData = category == 'all' 
                ? null 
                : FoodCategories.all.firstWhere((c) => c.id == category);
            
            return FilterChip(
              label: Text(categoryData?.name ?? 'All'),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
                _filterFoods();
              },
              avatar: categoryData != null 
                  ? Icon(categoryData.icon, size: 16) 
                  : const Icon(Icons.all_inclusive, size: 16),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDoshaFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Balancing Dosha'),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _selectedDosha == null,
              onSelected: (selected) {
                setState(() {
                  _selectedDosha = null;
                });
                _filterFoods();
              },
            ),
            ...Dosha.values.map((dosha) {
              final isSelected = _selectedDosha == dosha;
              return FilterChip(
                label: Text(dosha.displayName),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedDosha = selected ? dosha : null;
                  });
                  _filterFoods();
                },
                avatar: Icon(dosha.icon, size: 16),
                backgroundColor: dosha.color.withOpacity(0.1),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildRasaFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Taste (Rasa)'),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _selectedRasa == null,
              onSelected: (selected) {
                setState(() {
                  _selectedRasa = null;
                });
                _filterFoods();
              },
            ),
            ...Rasa.values.map((rasa) {
              final isSelected = _selectedRasa == rasa;
              return FilterChip(
                label: Text(rasa.displayName),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedRasa = selected ? rasa : null;
                  });
                  _filterFoods();
                },
                avatar: Icon(rasa.icon, size: 16),
                backgroundColor: rasa.color.withOpacity(0.3),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No foods found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Try adjusting your search or filters',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(
            onPressed: _clearFilters,
            child: const Text('Clear all filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _filteredFoods.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final food = _filteredFoods[index];
        return FoodCard(
          food: food,
          onTap: widget.onFoodSelected != null
              ? () => widget.onFoodSelected!(food)
              : () => _showFoodDetails(food),
          isSelectionMode: widget.isSelectionMode,
        );
      },
    );
  }

  void _showFoodDetails(FoodItem food) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FoodDetailPage(food: food),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback? onTap;
  final bool isSelectionMode;

  const FoodCard({
    Key? key,
    required this.food,
    this.onTap,
    this.isSelectionMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food image placeholder or category icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      color: _getCategoryColor().withOpacity(0.1),
                    ),
                    child: Icon(
                      _getCategoryIcon(),
                      size: 30,
                      color: _getCategoryColor(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  
                  // Food info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${food.category} • ${food.subcategory}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (food.description != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            food.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  if (isSelectionMode)
                    const Icon(Icons.add_circle_outline),
                ],
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Nutrition overview
              _buildNutritionOverview(theme),
              
              const SizedBox(height: AppSpacing.md),
              
              // Ayurvedic properties
              _buildAyurvedicProperties(theme),
              
              const SizedBox(height: AppSpacing.sm),
              
              // Tags
              if (food.tags.isNotEmpty)
                _buildTags(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionOverview(ThemeData theme) {
    return Row(
      children: [
        _buildNutrientChip('${food.nutrition.calories.round()} kcal', AppGradients.saffronGlow),
        const SizedBox(width: AppSpacing.sm),
        _buildNutrientChip('${food.nutrition.protein.toStringAsFixed(1)}g protein', AppGradients.nutritionProtein),
        const SizedBox(width: AppSpacing.sm),
        _buildNutrientChip('${food.nutrition.carbs.toStringAsFixed(1)}g carbs', AppGradients.nutritionCarbs),
      ],
    );
  }

  Widget _buildNutrientChip(String label, Gradient gradient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAyurvedicProperties(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ayurvedic Properties',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            // Rasas
            ...food.ayurvedicProperties.rasas.take(3).map((rasa) => 
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: Chip(
                  label: Text(rasa.displayName),
                  avatar: Icon(rasa.icon, size: 16),
                  backgroundColor: rasa.color,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            
            // Virya
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: food.ayurvedicProperties.virya.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: food.ayurvedicProperties.virya.color.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    food.ayurvedicProperties.virya.icon,
                    size: 14,
                    color: food.ayurvedicProperties.virya.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    food.ayurvedicProperties.virya.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: food.ayurvedicProperties.virya.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTags(ThemeData theme) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: food.tags.take(4).map((tag) =>
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            tag,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ).toList(),
    );
  }

  Color _getCategoryColor() {
    final categoryData = FoodCategories.all.firstWhere(
      (c) => c.id == food.category,
      orElse: () => const FoodCategory(
        id: 'other',
        name: 'Other',
        description: '',
        icon: Icons.fastfood,
        color: Colors.grey,
        subcategories: [],
      ),
    );
    return categoryData.color;
  }

  IconData _getCategoryIcon() {
    final categoryData = FoodCategories.all.firstWhere(
      (c) => c.id == food.category,
      orElse: () => const FoodCategory(
        id: 'other',
        name: 'Other',
        description: '',
        icon: Icons.fastfood,
        color: Colors.grey,
        subcategories: [],
      ),
    );
    return categoryData.icon;
  }
}

class FoodDetailPage extends StatelessWidget {
  final FoodItem food;

  const FoodDetailPage({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement sharing
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Add comprehensive food detail view
            Text(
              'Detailed food information will be displayed here',
              style: theme.textTheme.bodyLarge,
            ),
            // This would include:
            // - Comprehensive nutrition facts
            // - Detailed Ayurvedic properties
            // - Health benefits
            // - Preparation suggestions
            // - Recipe ideas
            // - Seasonal information
          ],
        ),
      ),
    );
  }
}