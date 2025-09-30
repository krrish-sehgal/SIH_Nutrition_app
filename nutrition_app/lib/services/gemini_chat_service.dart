import 'package:flutter_gemini/flutter_gemini.dart';
import '../models/patient_health_models.dart';

class GeminiChatService {
  // System prompt for Ayurvedic health coaching
  static const String _systemPrompt = '''
You are AyurBot, an expert Ayurvedic health coach and nutritionist. You provide personalized health guidance based on Ayurvedic principles. 

Your expertise includes:
- Ayurvedic constitution analysis (Vata, Pitta, Kapha doshas)
- Traditional remedies and herbs
- Seasonal eating guidelines
- Yoga and lifestyle recommendations
- Digestive health optimization
- Stress management through Ayurveda

Guidelines:
- Always consider the user's dosha when giving advice
- Provide practical, actionable suggestions
- Include traditional Ayurvedic wisdom
- Suggest natural remedies when appropriate
- Be warm, supportive, and encouraging
- Ask clarifying questions when needed
- Reference the six tastes (rasa) when discussing food
- Consider seasonal influences on health

Important: Always recommend consulting with healthcare professionals for serious health concerns.
  ''';

  static Future<String> sendMessage(String message, {
    String? userDosha,
    List<String>? healthConditions,
    Map<String, dynamic>? context,
  }) async {
    try {
      // Build context-aware prompt
      String contextualPrompt = _systemPrompt;
      
      if (userDosha != null) {
        contextualPrompt += '\nUser\'s Ayurvedic Constitution: $userDosha';
      }
      
      if (healthConditions != null && healthConditions.isNotEmpty) {
        contextualPrompt += '\nUser\'s Health Focus Areas: ${healthConditions.join(', ')}';
      }
      
      if (context != null) {
        contextualPrompt += '\nAdditional Context: ${context.toString()}';
      }

      final response = await Gemini.instance.text('$contextualPrompt\n\nUser Question: $message');

      print('Gemini API Response: ${response?.output}');

      return response?.output ?? 'I apologize, but I couldn\'t generate a response at the moment.';
      
    } catch (e) {
      print('Gemini API Error: $e');
      return _getFallbackResponse(message);
    }
  }

  // Fallback responses for when API is unavailable
  static String _getFallbackResponse(String message) {
    final lowercaseMessage = message.toLowerCase();
    
    if (lowercaseMessage.contains('diet') || lowercaseMessage.contains('food')) {
      return '''🌿 Based on Ayurvedic principles, here are some general dietary guidelines:

• Follow the six tastes (sweet, sour, salty, pungent, bitter, astringent) in each meal
• Eat your largest meal at lunch when digestive fire (Agni) is strongest
• Include warming spices like ginger, cumin, and turmeric
• Stay hydrated with warm water throughout the day

For personalized recommendations, I'd love to know more about your constitution (Vata, Pitta, or Kapha dominant). What's your typical energy pattern throughout the day?''';
    }
    
    if (lowercaseMessage.contains('sleep') || lowercaseMessage.contains('tired')) {
      return '''😴 For better sleep according to Ayurveda:

• Create a consistent bedtime routine
• Avoid screens 1 hour before bed
• Try a warm cup of golden milk with turmeric
• Practice gentle pranayama (breathing exercises)
• Keep your bedroom cool and dark

Quality sleep is essential for balancing all three doshas. How has your sleep pattern been lately?''';
    }
    
    if (lowercaseMessage.contains('stress') || lowercaseMessage.contains('anxiety')) {
      return '''🧘‍♀️ Ayurvedic stress management techniques:

• Practice daily meditation, even 5-10 minutes helps
• Try Abhyanga (self-massage) with warm sesame oil
• Include adaptogenic herbs like Ashwagandha
• Follow regular meal times to support nervous system
• Spend time in nature for grounding

Remember, consistent small practices are more beneficial than occasional intense ones. What time of day do you feel most stressed?''';
    }
    
    return '''🙏 Thank you for your question! While I'm temporarily unable to access my full knowledge base, I'm here to help with Ayurvedic wellness guidance.

I can assist you with:
• Dosha-specific nutrition advice
• Natural remedies and herbs
• Lifestyle recommendations
• Seasonal health tips
• Yoga and meditation guidance

Please feel free to ask about any specific health topic, and I'll do my best to provide helpful Ayurvedic insights!''';
  }

  // Predefined health coaching prompts
  static List<String> get suggestedPrompts => [
    "What foods should I eat for my dosha type?",
    "How can I improve my digestion naturally?",
    "What's the best morning routine for wellness?",
    "How do I balance my energy throughout the day?",
    "What herbs can help with stress management?",
    "How should I adjust my diet for the current season?",
    "What yoga poses are good for my constitution?",
    "How can I improve my sleep quality?",
    "What spices should I include in my meals?",
    "How do I know if my doshas are balanced?",
  ];

  // Health insights based on metrics
  static String generateHealthInsight(HealthMetrics metrics) {
    String insight = "🌟 Today's Ayurvedic Health Insight:\n\n";
    
    // Sleep analysis
    if (metrics.sleepHours < 7) {
      insight += "• Your sleep is below optimal. Try drinking warm milk with a pinch of nutmeg before bed to calm Vata and improve rest.\n\n";
    } else if (metrics.sleepHours > 8) {
      insight += "• Great sleep duration! This helps balance all three doshas and supports natural healing.\n\n";
    }
    
    // Activity analysis
    if (metrics.steps < 8000) {
      insight += "• Consider a gentle morning walk. Movement helps kindle Agni (digestive fire) and balance Kapha energy.\n\n";
    } else if (metrics.steps > 12000) {
      insight += "• Excellent activity level! Make sure to include some cooling practices if you feel overheated.\n\n";
    }
    
    // Hydration guidance
    if (metrics.waterIntake < 2.0) {
      insight += "• Increase warm water intake throughout the day. Room temperature or warm water supports digestion better than cold water.\n\n";
    }
    
    // Heart rate insights
    if (metrics.heartRate > 80) {
      insight += "• Your heart rate suggests some stress. Try 5 minutes of deep breathing (Pranayama) to calm Vata.\n\n";
    }
    
    insight += "Remember: Small, consistent changes create lasting wellness. 🙏";
    
    return insight;
  }
}