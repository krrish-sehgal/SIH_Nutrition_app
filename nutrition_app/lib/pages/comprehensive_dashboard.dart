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
        physics: const NeverScrollableScrollPhysics(), // Disable swipe gestures
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
        return _buildImpressiveAnalyticsDashboard();
      },
    );
  }

  Widget _buildImpressiveAnalyticsDashboard() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Improved visibility
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                  theme.colorScheme.primaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Practice Analytics',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Real-time insights & outcomes',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Key Metrics Row
          Row(
            children: [
              Expanded(child: _buildAnalyticsCard(
                '2,847',
                'Total Patients',
                Icons.people_outline,
                '+12%',
                Colors.green,
              )),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildAnalyticsCard(
                '1,924',
                'Active Plans',
                Icons.restaurant_menu,
                '+8%',
                Colors.blue,
              )),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildAnalyticsCard(
                '94.2%',
                'Success Rate',
                Icons.trending_up,
                '+2.1%',
                Colors.orange,
              )),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Charts Section - Mobile-friendly layout
          _buildPatientGrowthChart(),
          
          const SizedBox(height: AppSpacing.lg),
          
          _buildDoshaDistributionChart(),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Additional Metrics Cards
          _buildQuickMetricsRow(),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Revenue and Health Outcomes - Stack on mobile
          Column(
            children: [
              _buildRevenueChart(),
              const SizedBox(height: AppSpacing.lg),
              _buildHealthOutcomesChart(),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Patient Satisfaction & Top Conditions - Mobile-friendly layout
          Column(
            children: [
              _buildPatientSatisfactionCard(),
              const SizedBox(height: AppSpacing.lg),
              _buildTopConditionsCard(),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Geographic Distribution
          _buildGeographicDistribution(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String value, String title, IconData icon, String change, Color changeColor) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Icon(icon, color: theme.colorScheme.primary, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: changeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPatientGrowthChart() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient Growth',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Monthly new registrations',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, color: Colors.green, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '+23.4%',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${(value / 1000).toStringAsFixed(1)}k',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 2100), FlSpot(1, 2180), FlSpot(2, 2250), FlSpot(3, 2320),
                      FlSpot(4, 2400), FlSpot(5, 2480), FlSpot(6, 2550), FlSpot(7, 2620),
                      FlSpot(8, 2700), FlSpot(9, 2780), FlSpot(10, 2820), FlSpot(11, 2847),
                    ],
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: theme.colorScheme.primary,
                    barWidth: 4,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: theme.colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.colorScheme.primary.withOpacity(0.15),
                    ),
                  ),
                ],
                minY: 2000,
                maxY: 3000,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoshaDistributionChart() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dosha Distribution',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Patient constitution analysis',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '2,447 total',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Mobile-friendly layout: chart centered, legend below
          Center(
            child: SizedBox(
              height: 180,
              width: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: 35,
                          title: '35%',
                          color: const Color(0xFF2196F3),
                          radius: 70,
                          titleStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: 40,
                          title: '40%',
                          color: const Color(0xFFFF5722),
                          radius: 70,
                          titleStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: 25,
                          title: '25%',
                          color: const Color(0xFF4CAF50),
                          radius: 70,
                          titleStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.psychology,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Legend arranged vertically for better mobile experience
          Column(
            children: [
              _buildDoshaLegendItem('Vata Constitution', const Color(0xFF2196F3), 847),
              const SizedBox(height: 12),
              _buildDoshaLegendItem('Pitta Constitution', const Color(0xFFFF5722), 976),
              const SizedBox(height: 12),
              _buildDoshaLegendItem('Kapha Constitution', const Color(0xFF4CAF50), 624),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoshaLegendItem(String dosha, Color color, int count) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dosha,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.9),
                  ),
                ),
                Text(
                  '$count patients',
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
  }

  Widget _buildQuickMetricsRow() {
    return Row(
      children: [
        Expanded(child: _buildQuickMetricCard('Avg Recovery', '18 days', Icons.healing, Colors.blue)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildQuickMetricCard('Satisfaction', '4.8/5', Icons.star, Colors.orange)),
      ],
    );
  }

  Widget _buildQuickMetricCard(String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+5.2%',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Revenue',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹12,45,680',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '+18.5%',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 15,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Text(days[value.toInt() % 7], style: theme.textTheme.bodySmall);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: Colors.green)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 12, color: Colors.green)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 10, color: Colors.green)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 14, color: Colors.green)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 11, color: Colors.green)]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 9, color: Colors.green)]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 7, color: Colors.green)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthOutcomesChart() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Outcomes',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Patient improvement rates',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildOutcomeItem('Digestive Health', 0.92, Colors.green),
          _buildOutcomeItem('Weight Management', 0.88, Colors.blue),
          _buildOutcomeItem('Energy Levels', 0.95, Colors.orange),
          _buildOutcomeItem('Sleep Quality', 0.85, Colors.purple),
          _buildOutcomeItem('Stress Reduction', 0.78, Colors.teal),
        ],
      ),
    );
  }

  Widget _buildOutcomeItem(String title, double value, Color color) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: theme.textTheme.bodyMedium),
              Text('${(value * 100).toInt()}%', 
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientSatisfactionCard() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Patient Satisfaction',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'EXCELLENT',
                  style: TextStyle(
                    color: Colors.amber[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Rating display optimized for mobile
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '4.8',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[600],
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '/5',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) => Icon(
                  Icons.star,
                  color: index < 5 ? Colors.amber : Colors.grey[300],
                  size: 16,
                )),
              ),
              const SizedBox(height: 4),
              Text(
                'Based on 2,847 reviews',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Rating breakdown with improved layout
          ...[
            ('5 Star', 0.78, Colors.green, '78%'),
            ('4 Star', 0.15, Colors.lightGreen, '15%'),
            ('3 Star', 0.05, Colors.yellow[600]!, '5%'),
            ('2 Star', 0.015, Colors.orange, '1%'),
            ('1 Star', 0.005, Colors.red, '0%'),
          ].map((data) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 45,
                  child: Text(
                    data.$1,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[200],
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: data.$2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: data.$3,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 30,
                  child: Text(
                    data.$4,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: data.$3,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildTopConditionsCard() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Top Conditions Treated',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '3,433 total',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...[
            ('Digestive Issues', 847, Colors.green),
            ('Weight Management', 623, Colors.blue),
            ('Diabetes', 512, Colors.orange),
            ('Hypertension', 445, Colors.red),
            ('Stress & Anxiety', 398, Colors.purple),
            ('Joint Pain', 321, Colors.teal),
            ('Skin Conditions', 287, Colors.brown),
          ].map((condition) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: condition.$3,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    condition.$1,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${condition.$2}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: condition.$3,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildGeographicDistribution() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Geographic Distribution',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Patient locations across India',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ...[
                      ('Mumbai', 847, 0.35),
                      ('Delhi', 623, 0.28),
                      ('Bangalore', 512, 0.22),
                      ('Chennai', 445, 0.18),
                      ('Kolkata', 398, 0.15),
                    ].map((city) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: theme.colorScheme.primary, size: 16),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(city.$1, style: theme.textTheme.bodyMedium),
                          ),
                          Text(
                            '${city.$2}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 64,
                          color: theme.colorScheme.primary.withOpacity(0.6),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Interactive Map',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Coming Soon',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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