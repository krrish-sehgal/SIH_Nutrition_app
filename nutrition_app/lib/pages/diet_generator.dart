import '../core/app_export.dart';
import '../theme/app_styles.dart';

class DietGeneratorPage extends StatefulWidget {
  const DietGeneratorPage({super.key});

  @override
  State<DietGeneratorPage> createState() => _DietGeneratorPageState();
}

class _DietGeneratorPageState extends State<DietGeneratorPage> {
  final _formKey = GlobalKey<FormState>();
  String? _patientId;
  String? _selectedGoal;
  String? _selectedActivityLevel;
  String? _selectedPrakriti;
  bool _includeSnackReminders = true;
  bool _attachLifestyleTips = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    final notifier = context.read<PatientNotifier>();

    if (args is String && args.isNotEmpty && args != _patientId) {
      _patientId = args;
      notifier.selectPatient(args);
    }

    _patientId ??= notifier.selectedPatient.id;

    _selectedGoal ??= notifier.goalOptions.first;
    _selectedActivityLevel ??= notifier.activityLevels.first;
    _selectedPrakriti ??= notifier.selectedPatient.prakriti;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<PatientNotifier>();
    final patient = _resolvePatient(notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Diet generator', style: theme.textTheme.titleLarge),
            Text(
              '${patient.name} · ${patient.prakriti} prakriti',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Regenerate with current inputs',
            onPressed: () => _regenerate(context, notifier, patient.id),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.aurora),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PatientSummaryCard(patient: patient),
                      const SizedBox(height: 28),
                      const _SectionHeading(
                        title: 'Personalisation inputs',
                        subtitle:
                            'Align goals, activity, and dosha balance before generating the chart.',
                      ),
                      const SizedBox(height: 16),
                      _GlassDropdown(
                        label: 'Diet objective',
                        value: _selectedGoal,
                        items: notifier.goalOptions,
                        onChanged: (value) =>
                            setState(() => _selectedGoal = value),
                      ),
                      const SizedBox(height: 16),
                      _GlassDropdown(
                        label: 'Activity level',
                        value: _selectedActivityLevel,
                        items: notifier.activityLevels,
                        onChanged: (value) =>
                            setState(() => _selectedActivityLevel = value),
                      ),
                      const SizedBox(height: 16),
                      _GlassDropdown(
                        label: 'Target prakriti for plan',
                        value: _selectedPrakriti,
                        items: notifier.prakritiOptions,
                        onChanged: (value) =>
                            setState(() => _selectedPrakriti = value),
                      ),
                      const SizedBox(height: 24),
                      const _SectionHeading(
                        title: 'Optional enhancers',
                        subtitle:
                            'Toggle snack reminders or add daily lifestyle nudges to the final plan.',
                      ),
                      const SizedBox(height: 16),
                      _PreferenceToggle(
                        title: 'Include mid-meal snack reminders',
                        subtitle:
                            'Adds hydration rituals, herbal teas, and mindful snack prompts to the summary.',
                        value: _includeSnackReminders,
                        onChanged: (value) =>
                            setState(() => _includeSnackReminders = value),
                      ),
                      const SizedBox(height: 14),
                      _PreferenceToggle(
                        title: 'Attach daily lifestyle nudges',
                        subtitle:
                            'Bundle pranayama, bedtime rituals, and gentle mobility cues with the chart.',
                        value: _attachLifestyleTips,
                        onChanged: (value) =>
                            setState(() => _attachLifestyleTips = value),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              icon: const Icon(Icons.auto_awesome),
                              label: const Text('Generate personalised plan'),
                              style: FilledButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16)),
                              onPressed: () =>
                                  _onGenerate(context, notifier, patient.id),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.visibility_outlined),
                              label: const Text('Open most recent plan'),
                              style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16)),
                              onPressed:
                                  notifier.planForPatient(patient.id) == null
                                      ? null
                                      : () => Navigator.of(context).pushNamed(
                                          '/dietPlan',
                                          arguments: patient.id),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PatientProfile _resolvePatient(PatientNotifier notifier) {
    final fallback = notifier.selectedPatient;
    final id = _patientId ?? fallback.id;
    try {
      return notifier.patients.firstWhere((patient) => patient.id == id);
    } catch (_) {
      return fallback;
    }
  }

  void _regenerate(
      BuildContext context, PatientNotifier notifier, String patientId) {
    _onGenerate(context, notifier, patientId);
  }

  void _onGenerate(
      BuildContext context, PatientNotifier notifier, String patientId) {
    if (_selectedGoal == null ||
        _selectedActivityLevel == null ||
        _selectedPrakriti == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please fill in all inputs before generating the plan.')),
      );
      return;
    }

    final plan = notifier.generatePlanForPatient(
      patientId: patientId,
      goal: _selectedGoal!,
      activityLevel: _selectedActivityLevel!,
      prakriti: _selectedPrakriti!,
      includeSnacks: _includeSnackReminders,
      includeLifestyleTips: _attachLifestyleTips,
    );

    final addOns = <String>[];
    if (_includeSnackReminders) addOns.add('snack reminders');
    if (_attachLifestyleTips) addOns.add('lifestyle tips');

    final confirmation = addOns.isEmpty
        ? 'Generated ${plan.goal.toLowerCase()} plan for ${plan.patientName}.'
        : 'Generated ${plan.goal.toLowerCase()} plan with ${addOns.join(' & ')}.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(confirmation)),
    );

    Navigator.of(context)
        .pushReplacementNamed('/dietPlan', arguments: patientId);
  }
}

class _PatientSummaryCard extends StatelessWidget {
  const _PatientSummaryCard({required this.patient});

  final PatientProfile patient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: AppDecorations.glassSurface(context: context),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.saffronGlow,
                ),
                child: Icon(Icons.person_outline,
                    color: theme.colorScheme.onSecondary, size: 28),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Age ${patient.age} · ${patient.gender} · ${patient.prakriti} prakriti',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MiniInfoTile(
                icon: Icons.monitor_weight_outlined,
                label: '${patient.weight.toStringAsFixed(1)} kg',
                caption: 'Current weight',
              ),
              _MiniInfoTile(
                icon: Icons.self_improvement_outlined,
                label: patient.lifestyle,
                caption: 'Lifestyle snapshot',
              ),
              _MiniInfoTile(
                icon: Icons.water_drop_outlined,
                label: patient.waterIntake,
                caption: 'Hydration',
              ),
            ],
          ),
          if (patient.notes != null) ...[
            const SizedBox(height: 18),
            Text(
              'Practitioner notes',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              patient.notes!,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: patient.focusAreas
                .map(
                  (focus) => Chip(
                    label: Text(focus),
                    labelStyle: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700)),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _GlassDropdown extends StatelessWidget {
  const _GlassDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: TextStyle(color: theme.colorScheme.primary),
        filled: true,
        fillColor: theme.colorScheme.surface.withOpacity(0.92),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _PreferenceToggle extends StatelessWidget {
  const _PreferenceToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: AppDecorations.glassSurface(context: context).copyWith(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _MiniInfoTile extends StatelessWidget {
  const _MiniInfoTile(
      {required this.icon, required this.label, required this.caption});

  final IconData icon;
  final String label;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 240),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.glassSurface(context: context).copyWith(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
