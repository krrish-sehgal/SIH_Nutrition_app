import '../core/app_export.dart';

class PatientViewPage extends StatefulWidget {
  const PatientViewPage({Key? key}) : super(key: key);

  @override
  State<PatientViewPage> createState() => _PatientViewPageState();
}

class _PatientViewPageState extends State<PatientViewPage> {
  String? _patientId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final notifier = context.read<PatientNotifier>();
    _patientId ??= notifier.selectedPatient.id;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientNotifier>(
      builder: (context, notifier, _) {
        final patient = notifier.patients.firstWhere((p) => p.id == _patientId);
        final plan = notifier.planForPatient(patient.id);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Patient app preview'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _patientId,
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    items: notifier.patients
                        .map(
                          (patient) => DropdownMenuItem<String>(
                            value: patient.id,
                            child: Text(patient.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _patientId = value);
                      context.read<PatientNotifier>().selectPatient(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          body: plan == null
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                        'No plan yet. Ask your practitioner to generate a personalised chart.'),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _PatientTopCard(patient: patient, plan: plan),
                    const SizedBox(height: 20),
                    SwitchListTile.adaptive(
                      value: notifier.snackRemindersEnabled(patient.id),
                      title: const Text('Meal reminders'),
                      subtitle: const Text(
                          'Prototype notifications at meal times + hydration nudges'),
                      onChanged: (value) {
                        notifier.updateReminderPreference(
                            patientId: patient.id, enabled: value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(value
                                ? 'Meal reminders enabled for ${patient.name}.'
                                : 'Meal reminders paused.'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ...plan.meals.map(
                      (meal) => _PatientMealTile(
                        patientId: patient.id,
                        meal: meal,
                        onDone: () => _simulateCompletion(context, meal.slot),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.chat_bubble_outline,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                const SizedBox(width: 12),
                                Text(
                                  'Ask the in-app coach',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Prototype chatbot hooks ready. Patients can ask “What can I swap dinner with?” and receive AI-backed, dosha-safe options.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
        );
      },
    );
  }

  void _simulateCompletion(BuildContext context, String slot) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Marked $slot as completed. Hydration reminder will nudge in 45 minutes.'),
      ),
    );
  }
}

class _PatientTopCard extends StatelessWidget {
  const _PatientTopCard({required this.patient, required this.plan});

  final PatientProfile patient;
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
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    patient.name.substring(0, 1),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text('${patient.prakriti} prakriti • ${plan.goal}'),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${nutrition.calories} kcal',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text('Protein ${nutrition.protein} g'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(plan.summary),
          ],
        ),
      ),
    );
  }
}

class _PatientMealTile extends StatelessWidget {
  const _PatientMealTile({
    required this.patientId,
    required this.meal,
    required this.onDone,
  });

  final String patientId;
  final DietMeal meal;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final option = meal.currentOption;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(meal.slot.substring(0, 1)),
        ),
        title: Text('${meal.slot} • ${meal.timing}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(option.name),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: option.ayurvedicTags
                  .map((tag) => Chip(label: Text(tag)))
                  .toList(),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.check_circle_outline),
          onPressed: onDone,
        ),
        onTap: () => Navigator.of(context).pushNamed(
          '/mealDetail',
          arguments: MealDetailArgs(patientId: patientId, mealSlot: meal.slot),
        ),
      ),
    );
  }
}
