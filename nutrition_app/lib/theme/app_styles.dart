import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



// Enhanced gradients for modern UI
class AppGradients {
  static const LinearGradient aurora = LinearGradient(
    colors: [Color(0xFF2E6B5E), Color(0xFF1A4B40), Color(0xFF0F3B32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient saffronGlow = LinearGradient(
    colors: [Color(0xFFF2A541), Color(0xFFE8941F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient leafMidnight = LinearGradient(
    colors: [Color(0xFF2E6B5E), Color(0xFF1F4A3E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient terracotta = LinearGradient(
    colors: [Color(0xFF8C4A3E), Color(0xFF6B3428)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient patientPreview = LinearGradient(
    colors: [Color(0xFFF7F4EF), Color(0xFFEDE7D9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ayurvedicWisdom = LinearGradient(
    colors: [Color(0xFFFFE8B5), Color(0xFFFFDEA5), Color(0xFFFFF2CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient doshaVata = LinearGradient(
    colors: [Color(0xFFE8F5E8), Color(0xFFD1F2D1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient doshaPitta = LinearGradient(
    colors: [Color(0xFFFFF5E6), Color(0xFFFFEBCC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient doshaKapha = LinearGradient(
    colors: [Color(0xFFF0F8FF), Color(0xFFE6F3FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nutritionProtein = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A52)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nutritionCarbs = LinearGradient(
    colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nutritionFats = LinearGradient(
    colors: [Color(0xFFFFBE0B), Color(0xFFFB8500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nutritionFiber = LinearGradient(
    colors: [Color(0xFF95E1D3), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Enhanced decorations
class AppDecorations {
  static BoxDecoration glassSurface({required BuildContext context}) {
    final theme = Theme.of(context);
    return BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      color: theme.colorScheme.surface.withOpacity(0.9),
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withOpacity(0.3),
        width: 1,
      ),
      boxShadow: AppShadows.soft,
    );
  }

  static BoxDecoration neuomorphicCard({required BuildContext context}) {
    final theme = Theme.of(context);
    return BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      color: theme.colorScheme.surface,
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.shadow.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.7),
          blurRadius: 10,
          offset: const Offset(-5, -5),
        ),
      ],
    );
  }

  static BoxDecoration ayurvedicCard({
    required BuildContext context,
    required Gradient gradient,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: gradient,
      boxShadow: AppShadows.elevated,
    );
  }

  static BoxDecoration modernCard({required BuildContext context}) {
    final theme = Theme.of(context);
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: theme.colorScheme.surface,
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.shadow.withOpacity(0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

// Enhanced shadows
class AppShadows {
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get dramatic => [
        BoxShadow(
          color: Colors.black.withOpacity(0.16),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ];
}

// Ayurvedic-specific styling
class AyurvedicStyles {
  static const Map<String, Color> rasaColors = {
    'Sweet': Color(0xFFFFE4B5),
    'Sour': Color(0xFFFFB3BA),
    'Salty': Color(0xFFE6E6FA),
    'Pungent': Color(0xFFFFDAB9),
    'Bitter': Color(0xFFD3D3D3),
    'Astringent': Color(0xFFF0E68C),
  };

  static const Map<String, Color> doshaColors = {
    'Vata': Color(0xFF90EE90),
    'Pitta': Color(0xFFFFD700),
    'Kapha': Color(0xFF87CEEB),
  };

  static const Map<String, IconData> rasaIcons = {
    'Sweet': Icons.cake_outlined,
    'Sour': Icons.local_drink_outlined,
    'Salty': Icons.grain_outlined,
    'Pungent': Icons.local_fire_department_outlined,
    'Bitter': Icons.eco_outlined,
    'Astringent': Icons.spa_outlined,
  };

  static const Map<String, IconData> doshaIcons = {
    'Vata': Icons.air,
    'Pitta': Icons.local_fire_department,
    'Kapha': Icons.water_drop,
  };

  static const Map<String, String> doshaDescriptions = {
    'Vata': 'Air & Space • Movement & Change',
    'Pitta': 'Fire & Water • Transformation & Metabolism',
    'Kapha': 'Earth & Water • Structure & Lubrication',
  };
}

// Animation utilities
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve bounceInOut = Curves.bounceInOut;
  static const Curve elasticInOut = Curves.elasticInOut;
}

// Spacing constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

// Border radius constants  
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}
