import '../core/app_export.dart';
import '../theme/app_styles.dart';

class PractitionerDashboardPage extends StatelessWidget {
  const PractitionerDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AyurDiet Practitioner', style: theme.textTheme.titleLarge),
              Text(
                'Personalise. Prescribe. Share instantly.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.phone_iphone_outlined),
              tooltip: 'Patient app preview',
              onPressed: () => Navigator.of(context).pushNamed('/patientApp'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showPatientSelector(context),
          icon: const Icon(Icons.auto_awesome_outlined),
          label: const Text('Create new diet chart'),
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
          elevation: 3,
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDF8F3), Color(0xFFF7F1E7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Consumer<PatientNotifier>(
            builder: (context, notifier, _) {
              final totalMealPlans = notifier.patients
                  .where(
                      (patient) => notifier.planForPatient(patient.id) != null)
                  .length;
              final totalCalories =
                  notifier.activePlan?.totalNutrition.calories ?? 0;

              return ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                children: [
                  _DashboardIntro(
                      totalMealPlans: totalMealPlans,
                      totalCalories: totalCalories),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: notifier.patients
                        .map(
                          (patient) => _PatientCard(
                            patient: patient,
                            plan: notifier.planForPatient(patient.id),
                            onOpenProfile: () {
                              notifier.selectPatient(patient.id);
                              Navigator.of(context).pushNamed('/patientProfile',
                                  arguments: patient.id);
                            },
                            onGeneratePlan: () {
                              notifier.selectPatient(patient.id);
                              Navigator.of(context).pushNamed('/dietGenerator',
                                  arguments: patient.id);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              );
            },
          ),
        ));
  }

  void _showPatientSelector(BuildContext context) {
    final notifier = context.read<PatientNotifier>();
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Create diet chart for',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...notifier.patients.map(
                (patient) => ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(patient.name),
                  subtitle: Text(
                      '${patient.prakriti} · ${patient.healthTags.join(', ')}'),
                  onTap: () {
                    Navigator.of(context).pop();
                    notifier.selectPatient(patient.id);
                    Navigator.of(context)
                        .pushNamed('/dietGenerator', arguments: patient.id);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardIntro extends StatelessWidget {
  const _DashboardIntro({
    required this.totalMealPlans,
    required this.totalCalories,
  });

  final int totalMealPlans;
  final int totalCalories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppDecorations.glassSurface(context: context).copyWith(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface.withOpacity(0.95),
            theme.colorScheme.surface
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.saffronGlow,
                ),
                child: Icon(Icons.dashboard_customize_outlined,
                    color: theme.colorScheme.onSecondary, size: 28),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Holistic practice cockpit',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Track prakriti-tagged cohorts, auto-generate balanced charts, and sync with patients instantly.',
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
            spacing: 16,
            runSpacing: 12,
            children: [
              _MetricCard(
                icon: Icons.calendar_today_outlined,
                value: '$totalMealPlans',
                label: 'Active diet plans',
                gradient: AppGradients.leafMidnight,
              ),
              _MetricCard(
                icon: Icons.local_fire_department_outlined,
                value: totalCalories > 0 ? '$totalCalories kcal' : '--',
                label: 'Today’s reference energy',
                gradient: AppGradients.saffronGlow,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
  });

  final IconData icon;
  final String value;
  final String label;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 220),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: gradient,
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.onPrimary, size: 26),
          const SizedBox(height: 20),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({
    required this.patient,
    required this.plan,
    required this.onOpenProfile,
    required this.onGeneratePlan,
  });

  final PatientProfile patient;
  final DietPlan? plan;
  final VoidCallback onOpenProfile;
  final VoidCallback onGeneratePlan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: theme.colorScheme.surface,
        boxShadow: AppShadows.soft,
      ),
      padding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(0.12),
                  ),
                  child: Text(
                    patient.name.substring(0, 1).toUpperCase(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
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
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _MiniInfoPill(
                              icon: Icons.cake_outlined,
                              label: '${patient.age} yrs'),
                          _MiniInfoPill(
                              icon: Icons.wc_outlined, label: patient.gender),
                          _MiniInfoPill(
                              icon: Icons.nature_outlined,
                              label: '${patient.prakriti} prakriti'),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: patient.healthTags
                            .map((tag) => Chip(
                                  label: Text(tag),
                                  visualDensity: VisualDensity.compact,
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
            const SizedBox(height: 16),
            if (plan != null) ...[
              _PlanSnapshot(plan: plan!),
              const SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: onOpenProfile,
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Open profile'),
                ),
                ElevatedButton.icon(
                  onPressed: onGeneratePlan,
                  icon: const Icon(Icons.auto_fix_high_outlined),
                  label: const Text('Generate plan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanSnapshot extends StatelessWidget {
  const _PlanSnapshot({required this.plan});

  final DietPlan plan;

  @override
  Widget build(BuildContext context) {
    final nutrition = plan.totalNutrition;
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppGradients.patientPreview,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.summary,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              _MacroBadge(label: 'Kcal', value: nutrition.calories.toString()),
              _MacroBadge(label: 'Protein', value: '${nutrition.protein} g'),
              _MacroBadge(label: 'Carbs', value: '${nutrition.carbs} g'),
              _MacroBadge(label: 'Fats', value: '${nutrition.fats} g'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  const _MacroBadge({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text('$label: $value'),
      labelStyle:
          theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
      side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.2)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

class _MiniInfoPill extends StatelessWidget {
  const _MiniInfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.primary.withOpacity(0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
