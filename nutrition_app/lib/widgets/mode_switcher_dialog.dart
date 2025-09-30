import 'package:flutter/material.dart';

enum AppMode {
  practitioner,
  patient,
  admin,
}

class ModeSwitcherDialog extends StatelessWidget {
  const ModeSwitcherDialog({Key? key, this.currentMode = AppMode.practitioner}) : super(key: key);

  final AppMode currentMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.swap_horiz_rounded,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Switch App Mode',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you want to use AyurDiet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _ModeOption(
              icon: Icons.medical_services_outlined,
              title: 'Practitioner Mode',
              description: 'Create and manage diet charts for patients',
              isSelected: currentMode == AppMode.practitioner,
              onTap: () => _switchMode(context, AppMode.practitioner),
            ),
            const SizedBox(height: 12),
            _ModeOption(
              icon: Icons.person_outline,
              title: 'Patient Mode',
              description: 'View your personalized diet plan and track progress',
              isSelected: currentMode == AppMode.patient,
              onTap: () => _switchMode(context, AppMode.patient),
            ),
            const SizedBox(height: 12),
            _ModeOption(
              icon: Icons.admin_panel_settings_outlined,
              title: 'Admin Mode',
              description: 'Manage system settings and user accounts',
              isSelected: currentMode == AppMode.admin,
              onTap: () => _switchMode(context, AppMode.admin),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _switchMode(BuildContext context, AppMode mode) {
    Navigator.of(context).pop();
    
    // Show a loading indicator briefly
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate mode switching delay with proper context handling
    Future.delayed(const Duration(milliseconds: 800), () {
      // Check if the context is still valid before using it
      if (!context.mounted) return;
      
      Navigator.of(context).pop(); // Close loading
      
      // Navigate based on mode with error handling
      try {
        switch (mode) {
          case AppMode.practitioner:
            // Try named route first, fallback to pop if route doesn't exist
            try {
              Navigator.of(context).pushReplacementNamed('/practitioner');
            } catch (e) {
              Navigator.of(context).pop();
            }
            break;
          case AppMode.patient:
            try {
              Navigator.of(context).pushReplacementNamed('/patient');
            } catch (e) {
              Navigator.of(context).pop();
            }
            break;
          case AppMode.admin:
            try {
              Navigator.of(context).pushReplacementNamed('/admin');
            } catch (e) {
              Navigator.of(context).pop();
            }
            break;
        }
        
        // Show success message if context is still valid
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Switched to ${mode.name.toLowerCase()} mode'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      } catch (e) {
        // Handle navigation errors gracefully
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to switch mode: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    });
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary 
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected 
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surface,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.outline.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected 
                    ? theme.colorScheme.onPrimary 
                    : theme.colorScheme.onSurface,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected 
                          ? theme.colorScheme.primary 
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the mode switcher
void showModeSwitcher(BuildContext context, {AppMode currentMode = AppMode.practitioner}) {
  showDialog(
    context: context,
    builder: (context) => ModeSwitcherDialog(currentMode: currentMode),
  );
}