import '../core/app_export.dart';
import '../theme/app_styles.dart';

class ComprehensiveDashboardPage extends StatefulWidget {
  const ComprehensiveDashboardPage({Key? key}) : super(key: key);

  @override
  State<ComprehensiveDashboardPage> createState() => _ComprehensiveDashboardPageState();
}

class _ComprehensiveDashboardPageState extends State<ComprehensiveDashboardPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('AyurDiet Pro'),
            Text(
              'Comprehensive Ayurvedic Diet Management',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_android),
            onPressed: () {
              Navigator.pushNamed(context, '/modernPatientApp');
            },
            tooltip: 'Modern Patient App',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showNotifications(context);
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              _showSettings(context);
            },
            tooltip: 'Settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard_outlined), text: 'Dashboard'),
            Tab(icon: Icon(Icons.people_outline), text: 'Patients'),
            Tab(icon: Icon(Icons.restaurant_menu_outlined), text: 'Food DB'),
            Tab(icon: Icon(Icons.analytics_outlined), text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildPatientsTab(),
          _buildFoodDatabaseTab(),
          _buildAnalyticsTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildDashboardTab() {
    return Consumer<PatientNotifier>(
      builder: (context, notifier, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickStats(notifier),
              const SizedBox(height: AppSpacing.lg),
              _buildRecentActivity(notifier),
              const SizedBox(height: AppSpacing.lg),
              _buildQuickActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPatientsTab() {
    return Consumer<PatientNotifier>(
      builder: (context, notifier, _) {
        return Column(
          children: [
            // Search and filter bar
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search patients...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        // TODO: Implement patient search
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // TODO: Show filter options
                    },
                  ),
                ],
              ),
            ),
            
            // Patient list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: notifier.patients.length,
                separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final patient = notifier.patients[index];
                  final plan = notifier.planForPatient(patient.id);
                  
                  return _buildEnhancedPatientCard(patient, plan, notifier);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFoodDatabaseTab() {
    return const FoodSearchPage();
  }

  Widget _buildAnalyticsTab() {
    return Consumer<PatientNotifier>(
      builder: (context, notifier, _) {
        return const Center(
          child: Text('Enhanced Analytics Dashboard Coming Soon'),
        );
      },
    );
  }

  Widget _buildQuickStats(PatientNotifier notifier) {
    final theme = Theme.of(context);
    final totalPatients = notifier.patients.length;
    final activePlans = notifier.patients.where((p) => notifier.planForPatient(p.id) != null).length;
    final totalCalories = notifier.activePlan?.totalNutrition.calories ?? 0;
    
    return Container(
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
                Icons.dashboard_customize_outlined,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Practice Overview',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          
          Row(
            children: [
              Expanded(child: _buildStatCard(
                'Total Patients',
                '$totalPatients',
                Icons.people_outline,
                AppGradients.leafMidnight,
              )),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildStatCard(
                'Active Plans',
                '$activePlans',
                Icons.restaurant_menu_outlined,
                AppGradients.saffronGlow,
              )),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildStatCard(
                'Today\'s Calories',
                '${totalCalories.round()}',
                Icons.local_fire_department_outlined,
                AppGradients.terracotta,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Gradient gradient) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(PatientNotifier notifier) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Recent Activity',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          ...notifier.patients.take(3).map((patient) {
            final plan = notifier.planForPatient(patient.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      patient.name[0].toUpperCase(),
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan != null 
                              ? 'Diet plan generated for ${patient.name}'
                              : 'New patient: ${patient.name}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          plan?.generatedAt.toString().split(' ')[0] ?? 'Recently added',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'New Patient',
                  Icons.person_add_outlined,
                  () {
                    // TODO: Navigate to new patient form
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildActionButton(
                  'Generate Plan',
                  Icons.auto_awesome_outlined,
                  () {
                    _showPatientSelector();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Search Foods',
                  Icons.search_outlined,
                  () {
                    _tabController.animateTo(2); // Switch to Food DB tab
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildActionButton(
                  'View Reports',
                  Icons.assessment_outlined,
                  () {
                    _tabController.animateTo(3); // Switch to Analytics tab
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      ),
    );
  }

  Widget _buildEnhancedPatientCard(PatientProfile patient, DietPlan? plan, PatientNotifier notifier) {
    final theme = Theme.of(context);
    
    return Card(
      child: InkWell(
        onTap: () {
          notifier.selectPatient(patient.id);
          Navigator.of(context).pushNamed('/patientProfile', arguments: patient.id);
        },
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _getDoshaGradient(patient.prakriti),
                    ),
                    child: Text(
                      patient.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${patient.age} years • ${patient.gender} • ${patient.prakriti}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  IconButton(
                    onPressed: () {
                      notifier.selectPatient(patient.id);
                      Navigator.of(context).pushNamed('/enhancedDietGenerator', arguments: patient.id);
                    },
                    icon: const Icon(Icons.restaurant_menu_outlined),
                    tooltip: 'Generate Diet Plan',
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Health tags
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: patient.healthTags.map((tag) =>
                  Chip(
                    label: Text(tag),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: theme.colorScheme.secondaryContainer,
                  ),
                ).toList(),
              ),
              
              if (plan != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: AppGradients.patientPreview,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Active diet plan • ${plan.totalNutrition.calories} kcal/day',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Gradient _getDoshaGradient(String prakriti) {
    if (prakriti.toLowerCase().contains('vata')) return AppGradients.doshaVata;
    if (prakriti.toLowerCase().contains('pitta')) return AppGradients.doshaPitta;
    if (prakriti.toLowerCase().contains('kapha')) return AppGradients.doshaKapha;
    return AppGradients.leafMidnight;
  }

  Widget? _buildFloatingActionButton() {
    switch (_selectedIndex) {
      case 0: // Dashboard
        return FloatingActionButton.extended(
          onPressed: _showPatientSelector,
          icon: const Icon(Icons.auto_awesome),
          label: const Text('Quick Generate'),
        );
      case 1: // Patients
        return FloatingActionButton(
          onPressed: () {
            // TODO: Add new patient
          },
          child: const Icon(Icons.person_add),
          tooltip: 'Add Patient',
        );
      case 2: // Food DB
        return null; // Food search has its own UI
      case 3: // Analytics
        return FloatingActionButton(
          onPressed: () {
            // TODO: Export reports
          },
          child: const Icon(Icons.download),
          tooltip: 'Export Report',
        );
      default:
        return null;
    }
  }

  void _showPatientSelector() {
    final notifier = context.read<PatientNotifier>();
    
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    'Generate Diet Plan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: notifier.patients.length,
                      itemBuilder: (context, index) {
                        final patient = notifier.patients[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text(patient.name[0].toUpperCase()),
                          ),
                          title: Text(patient.name),
                          subtitle: Text('${patient.prakriti} • ${patient.healthTags.join(', ')}'),
                          onTap: () {
                            Navigator.of(context).pop();
                            notifier.selectPatient(patient.id);
                            Navigator.of(context).pushNamed('/enhancedDietGenerator', arguments: patient.id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('No new notifications at this time.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Text('Settings panel will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}