
import '../core/app_export.dart';
import '../theme/app_styles.dart';
import '../models/patient_health_models.dart';
import '../services/gemini_chat_service.dart';

// Health Metrics Page
class HealthMetricsPage extends StatelessWidget {
  const HealthMetricsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final healthData = PatientMockData.weeklyHealthData;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthOverview(context, healthData),
          const SizedBox(height: 20),
          _buildWeeklyCharts(context, healthData),
          const SizedBox(height: 20),
          _buildVitalsCard(context, healthData.last),
          const SizedBox(height: 20),
          _buildSleepAnalysis(context, healthData),
        ],
      ),
    );
  }

  Widget _buildHealthOverview(BuildContext context, List<HealthMetrics> data) {
    final today = data.last;
    final yesterday = data[data.length - 2];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildProgressCard(
                'Steps', 
                today.steps, 
                yesterday.steps,
                10000,
                Icons.directions_walk,
                Colors.green,
                context,
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildProgressCard(
                'Heart Rate', 
                today.heartRate.round(), 
                yesterday.heartRate.round(),
                80,
                Icons.favorite,
                Colors.red,
                context,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(String title, int current, int previous, int target, IconData icon, Color color, BuildContext context) {
    final progress = current / target;
    final change = current - previous;
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
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
                '$current',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress > 1 ? 1 : progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          const SizedBox(height: 4),
          Text(
            '${change > 0 ? '+' : ''}$change vs yesterday',
            style: TextStyle(
              fontSize: 10,
              color: change > 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCharts(BuildContext context, List<HealthMetrics> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Trends',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        return Text(days[value.toInt() % 7]);
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) => 
                      FlSpot(e.key.toDouble(), e.value.steps.toDouble() / 100)
                    ).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsCard(BuildContext context, HealthMetrics today) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Vitals',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildVitalCard('BP', today.vitals['bloodPressure'], Icons.monitor_heart)),
              const SizedBox(width: 12),
              Expanded(child: _buildVitalCard('SpO2', '${today.vitals['oxygenSaturation']}%', Icons.air)),
              const SizedBox(width: 12),
              Expanded(child: _buildVitalCard('Temp', '${today.vitals['temperature']}°F', Icons.thermostat)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue[600]),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSleepAnalysis(BuildContext context, List<HealthMetrics> data) {
    final avgSleep = data.map((d) => d.sleepHours).reduce((a, b) => a + b) / data.length;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Analysis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.bedtime, color: Colors.purple[600], size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${avgSleep.toStringAsFixed(1)} hours average',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sleep quality: ${avgSleep > 7.5 ? 'Excellent' : avgSleep > 6.5 ? 'Good' : 'Needs improvement'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Nutrition Tracking Page
class NutritionTrackingPage extends StatelessWidget {
  const NutritionTrackingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTodaysMeals(context),
          const SizedBox(height: 20),
          _buildNutritionGoals(context),
          const SizedBox(height: 20),
          _buildWaterIntake(context),
          const SizedBox(height: 20),
          _buildMealPlan(context),
        ],
      ),
    );
  }

  Widget _buildTodaysMeals(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Today\'s Meals',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMealCard('Breakfast', 'Golden Milk & Oats', '320 kcal', true),
          _buildMealCard('Lunch', 'Kitchari Bowl', '450 kcal', true),
          _buildMealCard('Snack', 'Almonds & Dates', '180 kcal', false),
          _buildMealCard('Dinner', 'Dal & Rice', '380 kcal', false),
        ],
      ),
    );
  }

  Widget _buildMealCard(String meal, String food, String calories, bool completed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: completed ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completed ? Colors.green : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  food,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            calories,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: completed ? Colors.green : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionGoals(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Goals',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildNutrientProgress('Calories', 1330, 1800, 'kcal', Colors.orange),
          const SizedBox(height: 12),
          _buildNutrientProgress('Protein', 45, 65, 'g', Colors.red),
          const SizedBox(height: 12),
          _buildNutrientProgress('Carbs', 180, 220, 'g', Colors.blue),
          const SizedBox(height: 12),
          _buildNutrientProgress('Fats', 35, 60, 'g', Colors.green),
        ],
      ),
    );
  }

  Widget _buildNutrientProgress(String nutrient, int current, int target, String unit, Color color) {
    final progress = current / target;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(nutrient),
            const Spacer(),
            Text('$current / $target $unit'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress > 1 ? 1 : progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildWaterIntake(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Water Intake',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text('2.1 / 3.0 L'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(8, (index) => Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: index < 5 ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.water_drop,
                  color: index < 5 ? Colors.white : Colors.grey,
                  size: 16,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlan(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.modernCard(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recommended Recipes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: PatientMockData.ayurvedicRecipes.length,
              itemBuilder: (context, index) {
                final recipe = PatientMockData.ayurvedicRecipes[index];
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(recipe.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${recipe.cookingTime} min • ${recipe.difficulty}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// AyurBot Chat Page
class AyurBotChatPage extends StatefulWidget {
  const AyurBotChatPage({Key? key}) : super(key: key);

  @override
  State<AyurBotChatPage> createState() => _AyurBotChatPageState();
}

class _AyurBotChatPageState extends State<AyurBotChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: "🙏 Namaste! I'm AyurBot, your personal Ayurvedic health companion. I'm here to help you with nutrition advice, wellness tips, and answer any questions about your health journey. How can I assist you today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) => _buildMessage(_messages[index]),
          ),
        ),
        _buildSuggestedPrompts(),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessage(ChatMessage message) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.psychology, 
                color: theme.colorScheme.onPrimaryContainer, 
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser 
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.secondaryContainer,
              child: Icon(
                Icons.person, 
                color: theme.colorScheme.onSecondaryContainer, 
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestedPrompts() {
    if (_messages.length > 2) return const SizedBox.shrink();
    
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: GeminiChatService.suggestedPrompts.length,
        itemBuilder: (context, index) {
          final prompt = GeminiChatService.suggestedPrompts[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                prompt,
                style: const TextStyle(fontSize: 12),
              ),
              onPressed: () => _sendMessage(prompt),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ask AyurBot anything...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.green[600],
              child: IconButton(
                onPressed: _isLoading ? null : () => _sendMessage(_messageController.text),
                icon: _isLoading 
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _messageController.clear();

    try {
      final response = await GeminiChatService.sendMessage(
        text.trim(),
        userDosha: 'Pitta-Vata',
        healthConditions: ['Weight Management', 'Digestive Health'],
      );

      final botMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(botMessage);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

// Bottom Sheets and Dialogs
class MealLoggingBottomSheet extends StatelessWidget {
  const MealLoggingBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log Your Meal',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  label: const Text('Search Food'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Recent Meals',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                _buildRecentMeal('Golden Milk Latte', '180 kcal'),
                _buildRecentMeal('Kitchari Bowl', '320 kcal'),
                _buildRecentMeal('Fruit Salad', '120 kcal'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMeal(String name, String calories) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orange[100],
        child: Icon(Icons.restaurant, color: Colors.orange[600]),
      ),
      title: Text(name),
      subtitle: Text(calories),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class WaterTrackingDialog extends StatelessWidget {
  const WaterTrackingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Water Intake'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.water_drop, size: 64, color: Colors.blue[600]),
          const SizedBox(height: 16),
          const Text('How much water did you drink?'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWaterButton('250ml', context),
              _buildWaterButton('500ml', context),
              _buildWaterButton('750ml', context),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildWaterButton(String amount, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added $amount to your daily intake!')),
        );
      },
      child: Text(amount),
    );
  }
}

class MoodTrackingBottomSheet extends StatelessWidget {
  const MoodTrackingBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moods = ['😊', '😐', '😔', '😤', '😴', '🤗', '💪'];
    final moodLabels = ['Happy', 'Neutral', 'Sad', 'Stressed', 'Tired', 'Grateful', 'Energetic'];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'How are you feeling?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: moods.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mood logged: ${moodLabels[index]}')),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(moods[index], style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 4),
                      Text(
                        moodLabels[index],
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class RecipesPage extends StatelessWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipes = PatientMockData.ayurvedicRecipes;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayurvedic Recipes'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: AppDecorations.modernCard(context: context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    recipe.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${recipe.cookingTime} min'),
                          const SizedBox(width: 16),
                          Icon(Icons.restaurant, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${recipe.servings} servings'),
                          const SizedBox(width: 16),
                          Icon(Icons.trending_up, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(recipe.difficulty),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: recipe.ayurvedicBenefits.map((benefit) => 
                          Chip(
                            label: Text(benefit, style: const TextStyle(fontSize: 12)),
                            backgroundColor: Colors.green[100],
                          )
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final achievements = PatientMockData.achievements;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.modernCard(context: context).copyWith(
              color: achievement.isUnlocked 
                  ? achievement.color.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: achievement.isUnlocked 
                        ? achievement.color.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    achievement.icon,
                    color: achievement.isUnlocked 
                        ? achievement.color 
                        : Colors.grey,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: achievement.isUnlocked 
                              ? Colors.black 
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.description,
                        style: TextStyle(
                          color: achievement.isUnlocked 
                              ? Colors.grey[700] 
                              : Colors.grey,
                        ),
                      ),
                      if (achievement.isUnlocked) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Unlocked ${_formatDate(achievement.unlockedAt)}',
                          style: TextStyle(
                            color: achievement.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}

class EmergencyOptionsDialog extends StatelessWidget {
  const EmergencyOptionsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Emergency Options'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.phone, color: Colors.red[600]),
            title: const Text('Call Emergency'),
            subtitle: const Text('911'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.local_hospital, color: Colors.blue[600]),
            title: const Text('Find Nearest Hospital'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.medication, color: Colors.green[600]),
            title: const Text('Medication Alert'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.contact_phone, color: Colors.orange[600]),
            title: const Text('Call Doctor'),
            subtitle: const Text('Dr. Sarah Johnson'),
            onTap: () {},
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}