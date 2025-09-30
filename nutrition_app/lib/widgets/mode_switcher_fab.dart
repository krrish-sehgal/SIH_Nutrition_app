import 'package:flutter/material.dart';
import 'mode_switcher_dialog.dart';

/// A floating action button for quick mode switching
class ModeSwitcherFAB extends StatelessWidget {
  const ModeSwitcherFAB({
    Key? key,
    this.currentMode = AppMode.practitioner,
    this.mini = true,
    this.heroTag,
  }) : super(key: key);

  final AppMode currentMode;
  final bool mini;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FloatingActionButton(
      mini: mini,
      heroTag: heroTag,
      onPressed: () => showModeSwitcher(context, currentMode: currentMode),
      backgroundColor: theme.colorScheme.surface.withOpacity(0.9),
      foregroundColor: theme.colorScheme.primary,
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.swap_horiz_rounded,
          size: 20,
        ),
      ),
    );
  }
}

/// A positioned mode switcher button for pages without AppBar
class PositionedModeSwitcher extends StatelessWidget {
  const PositionedModeSwitcher({
    Key? key,
    this.currentMode = AppMode.practitioner,
    this.top = 50,
    this.right = 20,
  }) : super(key: key);

  final AppMode currentMode;
  final double top;
  final double right;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Positioned(
      top: top,
      right: right,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.9),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => showModeSwitcher(context, currentMode: currentMode),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.swap_horiz_rounded,
                      color: theme.colorScheme.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Switch',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}