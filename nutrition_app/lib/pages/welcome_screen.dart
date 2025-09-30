import '../core/app_export.dart';
import '../theme/app_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.aurora),
        child: Stack(
          children: [
            Positioned(
              top: -height * 0.1,
              right: -width * 0.2,
              child: Container(
                width: width * 0.8,
                height: width * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              bottom: -height * 0.25,
              left: -width * 0.2,
              child: Container(
                width: width * 0.9,
                height: width * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.secondary.withOpacity(0.25),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Icon(Icons.spa,
                              color: theme.colorScheme.primary, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'AyurDiet Pro',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Holistic nutrition, intelligently orchestrated',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: width * 0.7,
                      child: Text(
                        'Fuse macronutrient precision with Ayurvedic rasa, guna and virya intelligence for every patient’s prakriti.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(0.88),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: double.infinity,
                        decoration: AppDecorations.glassSurface(context: context),
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Prototype showcase',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            const Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              alignment: WrapAlignment.start,
                              children: [
                                _HighlightChip(
                                    icon: Icons.people_alt_outlined,
                                    label: 'Patient cockpit with prakriti tags'),
                                _HighlightChip(
                                    icon: Icons.auto_awesome,
                                    label: 'AI diet generator with rasa/virya context'),
                                _HighlightChip(
                                    icon: Icons.notifications_active_outlined,
                                    label: 'Patient reminders & swap experiences'),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushReplacementNamed('/dashboard'),
                                    child: const Text(
                                        'Enter practitioner dashboard'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed('/patientApp'),
                                    child: const Text('Preview patient app'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightChip extends StatelessWidget {
  const _HighlightChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
