import '../core/app_export.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({Key? key}) : super(key: key);

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
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
        final patient = _resolvePatient(notifier);
        final plan = notifier.planForPatient(patient.id);

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(patient.name),
                Text(
                  '${patient.prakriti} prakriti · ${patient.healthTags.join(' / ')}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _ProfileHeader(patient: patient, plan: plan),
              const SizedBox(height: 20),
              _InfoCard(
                title: 'Lifestyle snapshot',
                icon: Icons.person_pin_circle_outlined,
                children: [
                  _InfoRow(label: 'Age', value: '${patient.age} yrs'),
                  _InfoRow(label: 'Gender', value: patient.gender),
                  _InfoRow(
                      label: 'Weight',
                      value: '${patient.weight.toStringAsFixed(1)} kg'),
                  _InfoRow(label: 'Lifestyle', value: patient.lifestyle),
                ],
              ),
              const SizedBox(height: 16),
              _InfoCard(
                title: 'Ayurvedic assessment',
                icon: Icons.bubble_chart_outlined,
                children: [
                  _InfoRow(label: 'Prakriti', value: patient.prakriti),
                  _InfoRow(
                      label: 'Digestive quality',
                      value: patient.digestionQuality),
                  _InfoRow(
                      label: 'Bowel movements', value: patient.bowelMovements),
                  _InfoRow(label: 'Hydration', value: patient.waterIntake),
                  if (patient.notes != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Practitioner note',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      patient.notes!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              _FocusAreaSection(focusAreas: patient.focusAreas),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.auto_fix_high_outlined),
                      label: const Text('Generate new plan'),
                      onPressed: () => Navigator.of(context)
                          .pushNamed('/dietGenerator', arguments: patient.id),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.restaurant_menu_outlined),
                      label: const Text('View current plan'),
                      onPressed: plan == null
                          ? null
                          : () => Navigator.of(context)
                              .pushNamed('/dietChart', arguments: patient.id),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share plan to patient app'),
                onPressed: plan == null
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Prototype: plan ready to sync with patient app.'),
                          ),
                        );
                      },
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  PatientProfile _resolvePatient(PatientNotifier notifier) {
    if (_patientId == null) {
      return notifier.selectedPatient;
    }
    return notifier.patients.firstWhere((p) => p.id == _patientId);
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.patient, required this.plan});

  final PatientProfile patient;
  final DietPlan? plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  patient.name.substring(0, 1),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${patient.prakriti} prakriti • ${patient.healthTags.first}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: patient.healthTags
                          .map((tag) => Chip(
                                label: Text(tag),
                                backgroundColor:
                                    theme.colorScheme.secondaryContainer,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (plan != null)
            _PlanOverview(plan: plan!)
          else
            Text(
              'No active diet chart yet. Generate a personalised plan to get started.',
              style: theme.textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}

class _PlanOverview extends StatelessWidget {
  const _PlanOverview({required this.plan});

  final DietPlan plan;

  @override
  Widget build(BuildContext context) {
    final nutrition = plan.totalNutrition;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current plan',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(plan.summary, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            Chip(label: Text('Calories: ${nutrition.calories} kcal')),
            Chip(label: Text('Protein: ${nutrition.protein} g')),
            Chip(label: Text('Carbs: ${nutrition.carbs} g')),
            Chip(label: Text('Fats: ${nutrition.fats} g')),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Generated on ${DateFormat('dd MMM yyyy, hh:mm a').format(plan.generatedAt)}',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
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
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _FocusAreaSection extends StatelessWidget {
  const _FocusAreaSection({required this.focusAreas});

  final List<String> focusAreas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                Icon(Icons.flag_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Focus areas & care plan reminders',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: focusAreas
                  .map(
                    (area) => Chip(
                      label: Text(area),
                      avatar: const Icon(Icons.check_circle_outline, size: 18),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
