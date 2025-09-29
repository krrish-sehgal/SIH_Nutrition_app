import '../core/app_export.dart';

class MealDetailPage extends StatelessWidget {
  const MealDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! MealDetailArgs) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Meal detail'),
        ),
        body: const Center(child: Text('No meal selected.')),
      );
    }

    return Consumer<PatientNotifier>(
      builder: (context, notifier, _) {
        final meal = notifier.mealForPatient(args.patientId, args.mealSlot);
        if (meal == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${args.mealSlot} details'),
            ),
            body: const Center(
                child: Text('Meal not found in the current plan.')),
          );
        }
        final option = meal.currentOption;
        final plan = notifier.planForPatient(args.patientId);

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${meal.slot} breakdown'),
                if (plan != null)
                  Text(
                    plan.patientName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.swap_horiz_outlined),
                tooltip: 'Swap alternative',
                onPressed: () {
                  notifier.swapMealForPatient(args.patientId, meal.slot);
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(meal.guidance ??
                          'Ayurvedic-friendly preparation focused on balance.'),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            avatar: const Icon(
                                Icons.local_fire_department_outlined,
                                size: 18),
                            label: Text('${option.nutrition.calories} kcal'),
                          ),
                          Chip(
                              label: Text(
                                  'Protein: ${option.nutrition.protein} g')),
                          Chip(
                              label:
                                  Text('Carbs: ${option.nutrition.carbs} g')),
                          Chip(label: Text('Fats: ${option.nutrition.fats} g')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _SectionCard(
                icon: Icons.spa_outlined,
                title: 'Ayurvedic tags',
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: option.ayurvedicTags
                        .map((tag) => Chip(label: Text(tag)))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rasa spectrum',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: option.rasaProfiles
                        .map((rasa) => Chip(
                              avatar:
                                  const Icon(Icons.flare_outlined, size: 18),
                              label: Text(rasa),
                            ))
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                icon: Icons.shopping_basket_outlined,
                title: 'Ingredients & prep',
                children: [
                  ...option.ingredients.map(
                    (ingredient) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.circle, size: 10),
                      title: Text(ingredient),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(option.notes,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 16),
              if (meal.options.length > 1)
                _AlternativesList(
                  patientId: args.patientId,
                  meal: meal,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _AlternativesList extends StatelessWidget {
  const _AlternativesList({required this.patientId, required this.meal});

  final String patientId;
  final DietMeal meal;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.sync_alt_outlined,
      title: 'Alternatives available',
      children: [
        ...List.generate(meal.options.length, (index) {
          final option = meal.options[index];
          final isActive = index == meal.selectedIndex;
          return ListTile(
            leading: Icon(
              isActive
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isActive ? Theme.of(context).colorScheme.primary : null,
            ),
            title: Text(option.name),
            subtitle: Text(
                '${option.nutrition.calories} kcal • ${option.ayurvedicTags.join(', ')}'),
            trailing: TextButton(
              onPressed: isActive
                  ? null
                  : () => context.read<PatientNotifier>().setMealOption(
                      patientId: patientId,
                      slot: meal.slot,
                      optionIndex: index),
              child: Text(isActive ? 'Selected' : 'Switch'),
            ),
          );
        }),
      ],
    );
  }
}
