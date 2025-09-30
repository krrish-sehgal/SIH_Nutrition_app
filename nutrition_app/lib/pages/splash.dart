import '../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToWelcome();
  }

  Future<void> _navigateToWelcome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to make it responsive
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Top floating rounded rectangle
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/splash/upper-rec.png',
              width: width * 0.9, // Adjust width as needed
              fit: BoxFit.fill,
            ),
          ),
          // Bottom floating rounded rectangle
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/splash/lower-rec.png',
              width: width * 0.8, // Adjust width as needed
              fit: BoxFit.fill,
            ),
          ),
          // Center logo and text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/splash/logo.png', // Your logo path in assets
                  width: width, // Scale logo size relative to screen width
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
