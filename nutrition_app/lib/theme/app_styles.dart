import 'package:flutter/material.dart';

import 'theme.dart';

class AppGradients {
  static const LinearGradient aurora = LinearGradient(
    colors: [Color(0xFF2E6B5E), Color(0xFF1F4F45), Color(0xFF143E3A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient saffronGlow = LinearGradient(
    colors: [Color(0xFFFFC46B), Color(0xFFF09D4C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient leafMidnight = LinearGradient(
    colors: [Color(0xFF1F574C), Color(0xFF132D2A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient patientPreview = LinearGradient(
    colors: [Color(0xFFFBEFD8), Color(0xFFF9E7C0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppShadows {
  static final List<BoxShadow> soft = [
    BoxShadow(
      color: AppTheme.colorScheme.primary.withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}

class AppDecorations {
  static BoxDecoration glassSurface({required BuildContext context}) {
    return BoxDecoration(
      color: AppTheme.colorScheme.surface.withOpacity(0.84),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(
          color: AppTheme.colorScheme.outlineVariant.withOpacity(0.4)),
      boxShadow: AppShadows.soft,
    );
  }
}
