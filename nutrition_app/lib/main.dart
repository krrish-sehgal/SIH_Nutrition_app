import 'core/app_export.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
        '/welcome': (context) => const WelcomeScreen(),
        '/dashboard': (context) => const PractitionerDashboardPage(),
        '/patientProfile': (context) => const PatientProfilePage(),
        '/dietGenerator': (context) => const DietGeneratorPage(),
        '/dietChart': (context) => const DietPlanViewPage(),
        '/mealDetail': (context) => const MealDetailPage(),
        '/patientApp': (context) => const PatientViewPage(),
      },
    );
  }
}
