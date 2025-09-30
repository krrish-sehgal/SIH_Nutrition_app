
import '../core/app_export.dart';
import '../theme/app_styles.dart';
import '../models/patient_health_models.dart';
import '../services/gemini_chat_service.dart';
import '../widgets/patient_widgets.dart';

class ModernPatientDashboard extends StatefulWidget {
  const ModernPatientDashboard({Key? key}) : super(key: key);

  @override
  State<ModernPatientDashboard> createState() => _ModernPatientDashboardState();
}

class _ModernPatientDashboardState extends State<ModernPatientDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<HealthMetrics> _healthData = PatientMockData.weeklyHealthData;
  final WearableData _wearableData = PatientMockData.appleWatchData;
  String _todayInsight = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _animationController.forward();
    _generateTodayInsight();
  }

  void _generateTodayInsight() async {
    if (_healthData.isNotEmpty) {
      try {
        // Test the Gemini API with a simple message
        final insight = await GeminiChatService.sendMessage(
          'Based on my health data, give me a brief Ayurvedic insight for today.',
          userDosha: 'Pitta-Vata',
        );
        setState(() {
          _todayInsight = insight;
        });
      } catch (e) {
        print('Error generating insight: $e');
        setState(() {
          _todayInsight = GeminiChatService.generateHealthInsight(_healthData.last);
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(theme),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDashboardTab(),
            _buildHealthTab(),
            _buildNutritionTab(),
            _buildChatTab(),
            _buildProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(theme),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(Icons.person, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back, Sarah',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Pitta-Vata Constitution • Day 15 of your journey',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.local_fire_department, color: Colors.orange[300]),
                              Text(
                                '15',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'streak',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Overview
            _buildTodayOverview(),
            const SizedBox(height: 20),
            
            // Apple Health Integration
            _buildAppleHealthCard(),
            const SizedBox(height: 20),
            
            // Today's Insight
            _buildInsightCard(),
            const SizedBox(height: 20),
            
            // Quick Actions
            _buildQuickActions(),
            const SizedBox(height: 20),
            
            // Achievements
            _buildAchievementsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayOverview() {
    final today = _healthData.last;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMetricCard(
                'Steps',
                '${today.steps}',
                Icons.directions_walk,
                Colors.green,
                '${(today.steps / 10000 * 100).round()}%',
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard(
                'Heart Rate',
                '${today.heartRate.round()}',
                Icons.favorite,
                Colors.red,
                'BPM',
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMetricCard(
                'Sleep',
                '${today.sleepHours}h',
                Icons.bedtime,
                Colors.purple,
                '${(today.sleepHours / 8 * 100).round()}%',
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard(
                'Water',
                '${today.waterIntake}L',
                Icons.water_drop,
                Colors.blue,
                '${(today.waterIntake / 3 * 100).round()}%',
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color, String subtitle) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppleHealthCard() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context).copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.health_and_safety, 
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _wearableData.deviceName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Last sync: ${_formatSyncTime(_wearableData.lastSync)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sync, size: 16, color: Colors.green[700]),
                    const SizedBox(width: 4),
                    Text(
                      'Synced',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildHealthStat('Workouts', '2', 'today'),
              ),
              Expanded(
                child: _buildHealthStat('Active Cal', '285', 'kcal'),
              ),
              Expanded(
                child: _buildHealthStat('Resting HR', '65', 'bpm'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStat(String label, String value, String unit) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          unit,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context).copyWith(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondary.withOpacity(0.1),
            theme.colorScheme.secondaryContainer.withOpacity(0.2),
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
              Icon(
                Icons.lightbulb, 
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 12),
              Text(
                'Today\'s Ayurvedic Insight',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _todayInsight.isNotEmpty ? _todayInsight : 'Loading personalized insights...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              'Log Meal',
              Icons.camera_alt,
              Colors.orange,
              () => _showMealLogging(),
            ),
            _buildActionCard(
              'Water Reminder',
              Icons.water_drop,
              Colors.blue,
              () => _showWaterTracking(),
            ),
            _buildActionCard(
              'Mood Check',
              Icons.mood,
              Colors.purple,
              () => _showMoodTracking(),
            ),
            _buildActionCard(
              'Recipes',
              Icons.book,
              Colors.green,
              () => _showRecipes(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    final achievements = PatientMockData.achievements;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Achievements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _showAllAchievements(),
              child: Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: achievement.isUnlocked 
                            ? achievement.color.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: achievement.isUnlocked 
                              ? achievement.color 
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        achievement.icon,
                        color: achievement.isUnlocked 
                            ? achievement.color 
                            : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      achievement.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: achievement.isUnlocked 
                            ? Colors.black87 
                            : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHealthTab() {
    return HealthMetricsPage();
  }

  Widget _buildNutritionTab() {
    return NutritionTrackingPage();
  }

  Widget _buildChatTab() {
    return AyurBotChatPage();
  }

  Widget _buildProfileTab() {
    return PatientProfilePage();
  }

  Widget _buildBottomNavBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
            indicatorColor: Colors.transparent,
            labelStyle: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 9,
            ),
            unselectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 9,
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 2),
            tabs: const [
              Tab(
                icon: Icon(Icons.dashboard, size: 20), 
                text: 'Home',
                iconMargin: EdgeInsets.only(bottom: 1),
              ),
              Tab(
                icon: Icon(Icons.favorite, size: 20), 
                text: 'Health',
                iconMargin: EdgeInsets.only(bottom: 1),
              ),
              Tab(
                icon: Icon(Icons.restaurant, size: 20), 
                text: 'Food',
                iconMargin: EdgeInsets.only(bottom: 1),
              ),
              Tab(
                icon: Icon(Icons.chat, size: 20), 
                text: 'Chat',
                iconMargin: EdgeInsets.only(bottom: 1),
              ),
              Tab(
                icon: Icon(Icons.person, size: 20), 
                text: 'Profile',
                iconMargin: EdgeInsets.only(bottom: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showEmergencyOptions(),
      backgroundColor: Colors.red[400],
      child: const Icon(Icons.emergency, color: Colors.white),
    );
  }

  String _formatSyncTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  // Action methods
  void _showMealLogging() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MealLoggingBottomSheet(),
    );
  }

  void _showWaterTracking() {
    showDialog(
      context: context,
      builder: (context) => WaterTrackingDialog(),
    );
  }

  void _showMoodTracking() {
    showModalBottomSheet(
      context: context,
      builder: (context) => MoodTrackingBottomSheet(),
    );
  }

  void _showRecipes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipesPage()),
    );
  }

  void _showAllAchievements() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AchievementsPage()),
    );
  }

  void _showEmergencyOptions() {
    showDialog(
      context: context,
      builder: (context) => EmergencyOptionsDialog(),
    );
  }
}