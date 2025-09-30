import '../core/app_export.dart';
import '../widgets/custom_back_app_bar.dart';

class DietPlanViewPage extends StatefulWidget {
  const DietPlanViewPage({Key? key}) : super(key: key);

  @override
  State<DietPlanViewPage> createState() => _DietPlanViewPageState();
}

class _DietPlanViewPageState extends State<DietPlanViewPage> {
  String? _patientId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args != _patientId) {
      _patientId = args;
      context.read<PatientNotifier>().selectPatient(args);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientNotifier>(
      builder: (context, notifier, _) {
        final patient = _patientId != null
            ? notifier.patients.firstWhere((p) => p.id == _patientId)
            : notifier.selectedPatient;
        final plan = notifier.planForPatient(patient.id);
        final includeSnacks = notifier.snackRemindersEnabled(patient.id);
        final showLifestyleTips = notifier.lifestyleTipsEnabled(patient.id);

        return Scaffold(
          appBar: CustomBackAppBar(
            title: '${patient.name}\'s diet chart',
            subtitle: '${plan?.goal ?? '—'} · ${patient.prakriti} prakriti',
            actions: [
              IconButton(
                icon: const Icon(Icons.ios_share_outlined),
                tooltip: 'Share / export',
                onPressed: plan == null
                    ? null
                    : () => _showShareSheet(context, patient.id),
              ),
            ],
          ),
          floatingActionButton: plan == null
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _showShareSheet(context, patient.id),
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('Export / Share'),
                ),
          body: plan == null
              ? _EmptyPlanState(patientId: patient.id)
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _PlanHeader(plan: plan),
                    const SizedBox(height: 20),
                    ...plan.meals.map(
                      (meal) => _MealCard(
                        patientId: patient.id,
                        meal: meal,
                        onSwap: () =>
                            notifier.swapMealForPatient(patient.id, meal.slot),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (showLifestyleTips)
                      _LifestyleTips(includeSnacks: includeSnacks),
                    const SizedBox(height: 80),
                  ],
                ),
        );
      },
    );
  }

  void _showShareSheet(BuildContext context, String patientId) {
    final plan = context.read<PatientNotifier>().planForPatient(patientId);
    if (plan == null) return;

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                leading: Icon(Icons.picture_as_pdf_outlined),
                title: Text('Export as PDF (prototype)'),
                subtitle: Text(
                    'Preview-ready layout for printing and ABDM compliance.'),
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share with patient app'),
                subtitle: Text(
                    'Send to ${plan.patientName}\'s mobile view with reminders.'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Prototype: shared plan with ${plan.patientName}.'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: const Text('Archive to ABDM vault'),
                subtitle: const Text(
                    'Secure storage stub aligned with digital health stack.'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Prototype: simulated ABDM archival complete.'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlanHeader extends StatelessWidget {
  const _PlanHeader({required this.plan});

  final DietPlan plan;

  @override
  Widget build(BuildContext context) {
    final nutrition = plan.totalNutrition;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.summary,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                Chip(
                  avatar: const Icon(Icons.local_fire_department_outlined,
                      size: 18),
                  label: Text('${nutrition.calories} kcal'),
                ),
                Chip(
                  avatar: const Icon(Icons.fitness_center_outlined, size: 18),
                  label: Text('${nutrition.protein} g protein'),
                ),
                Chip(
                  avatar: const Icon(Icons.grain_outlined, size: 18),
                  label: Text('${nutrition.carbs} g carbs'),
                ),
                Chip(
                  avatar: const Icon(Icons.water_drop_outlined, size: 18),
                  label: Text('${nutrition.fats} g fats'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Generated ${DateFormat('d MMM, h:mm a').format(plan.generatedAt)} • ${plan.activityLevel} lifestyle',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.patientId,
    required this.meal,
    required this.onSwap,
  });

  final String patientId;
  final DietMeal meal;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    final option = meal.currentOption;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).pushNamed(
          '/mealDetail',
          arguments: MealDetailArgs(patientId: patientId, mealSlot: meal.slot),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.slot,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${meal.timing} • ${option.name}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: onSwap,
                    icon: const Icon(Icons.swap_horiz_outlined),
                    tooltip: 'Swap alternative',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text('${option.nutrition.calories} kcal'),
                    avatar: const Icon(Icons.local_fire_department_outlined,
                        size: 18),
                  ),
                  Chip(
                    label: Text('${option.nutrition.protein}g P'),
                  ),
                  Chip(
                    label: Text('${option.nutrition.carbs}g C'),
                  ),
                  Chip(
                    label: Text('${option.nutrition.fats}g F'),
                  ),
                  ...option.ayurvedicTags
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      )
                      .toList(),
                ],
              ),
              if (meal.guidance != null) ...[
                const SizedBox(height: 12),
                Text(
                  meal.guidance!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LifestyleTips extends StatelessWidget {
  const _LifestyleTips({required this.includeSnacks});

  final bool includeSnacks;

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Morning: 5 min pranayama + 500ml warm jeera water.',
      'Mid-day: 10 min mindful walk post lunch to support lymphatic flow.',
      'Evening: Digital sunset 60 mins before bed; journal gratitude + 4-7-8 breathing.',
    ];

    if (includeSnacks) {
      tips.insert(1,
          'Snack reminder: Herbal tea with fennel & cumin at 4:30 PM to aid digestion.');
    }

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
                Icon(Icons.self_improvement_outlined,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Lifestyle nudges',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPlanState extends StatelessWidget {
  const _EmptyPlanState({required this.patientId});

  final String patientId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.note_add_outlined, size: 56),
            const SizedBox(height: 16),
            Text(
              'No diet chart yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Build a personalised plan that balances modern macros with Ayurvedic rasa, guna, and virya insights.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate now'),
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed('/dietGenerator', arguments: patientId),
            ),
          ],
        ),
      ),
    );
  }
}
