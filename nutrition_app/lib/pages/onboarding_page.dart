import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../theme/app_styles.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Ancient Wisdom,\nModern Technology',
      description: 'Combine 5000-year-old Ayurvedic principles with cutting-edge nutrition science for personalized diet planning.',
      icon: Icons.spa,
      gradient: AppGradients.aurora,
      features: [
        'Prakriti-based recommendations',
        'Six taste (Rasa) analysis',
        'Dosha balancing foods',
      ],
    ),
    OnboardingItem(
      title: 'Comprehensive\nFood Database',
      description: 'Access 8,000+ Indian, international and regional foods with complete nutritional and Ayurvedic properties.',
      icon: Icons.restaurant_menu,
      gradient: AppGradients.saffronGlow,
      features: [
        '8000+ food items',
        'Nutritional analysis',
        'Ayurvedic properties',
      ],
    ),
    OnboardingItem(
      title: 'AI-Powered\nDiet Generation',
      description: 'Generate personalized diet charts in seconds using AI that understands both nutrition and Ayurveda.',
      icon: Icons.auto_awesome,
      gradient: AppGradients.leafMidnight,
      features: [
        'Instant diet generation',
        'Custom meal planning',
        'Smart recommendations',
      ],
    ),
    OnboardingItem(
      title: 'Professional\nPractice Management',
      description: 'Manage patients, track progress, generate reports, and scale your Ayurvedic nutrition practice.',
      icon: Icons.business_center,
      gradient: AppGradients.terracotta,
      features: [
        'Patient management',
        'Progress tracking',
        'Professional reports',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: _onboardingItems[_currentIndex].gradient,
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: _onboardingItems.length,
                    itemBuilder: (context, index) {
                      return _buildOnboardingPage(_onboardingItems[index], theme);
                    },
                  ),
                ),
                
                // Bottom navigation
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingItems.length,
                          (index) => _buildPageIndicator(index),
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Navigation buttons
                      Row(
                        children: [
                          if (_currentIndex > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _previousPage,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                                ),
                                child: const Text('Previous'),
                              ),
                            ),
                          
                          if (_currentIndex > 0)
                            const SizedBox(width: AppSpacing.md),
                          
                          Expanded(
                            flex: _currentIndex == 0 ? 1 : 1,
                            child: ElevatedButton(
                              onPressed: _currentIndex == _onboardingItems.length - 1
                                  ? _completeOnboarding
                                  : _nextPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: theme.colorScheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                              ),
                              child: Text(
                                _currentIndex == _onboardingItems.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item, ThemeData theme) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: AppAnimations.easeInOutCubic,
            )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      item.icon,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Title
                  Text(
                    item.title,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Description
                  Text(
                    item.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Features
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: item.features.map((feature) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentIndex;
    
    return AnimatedContainer(
      duration: AppAnimations.fast,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: AppAnimations.medium,
      curve: AppAnimations.easeInOutCubic,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: AppAnimations.medium,
      curve: AppAnimations.easeInOutCubic,
    );
  }

  void _skipOnboarding() {
    Navigator.of(context).pushReplacementNamed('/welcome');
  }

  void _completeOnboarding() {
    Navigator.of(context).pushReplacementNamed('/welcome');
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;
  final List<String> features;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.features,
  });
}