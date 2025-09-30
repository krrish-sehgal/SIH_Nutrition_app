import 'package:flutter_gemini/flutter_gemini.dart';

import 'core/app_export.dart';
import 'pages/modern_patient_dashboard.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY']!);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      title: 'Nutrition App',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingPage(),
        '/welcome': (context) => const WelcomeScreen(),
        '/dashboard': (context) => const ComprehensiveDashboardPage(),
        '/oldDashboard': (context) => const PractitionerDashboardPage(),
        '/patientProfile': (context) => const PatientProfilePage(),
        '/dietGenerator': (context) => const DietGeneratorPage(),
        '/enhancedDietGenerator': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return EnhancedDietGeneratorPage(patientId: args ?? '');
        },
        '/foodSearch': (context) => const FoodSearchPage(),
        '/dietChart': (context) => const DietPlanViewPage(),
        '/mealDetail': (context) => const MealDetailPage(),
        '/patientApp': (context) => const ModernPatientDashboard(),
      },
    );
  }
}
