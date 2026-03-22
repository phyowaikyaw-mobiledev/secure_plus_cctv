import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/language_button.dart';
import '../../../../l10n/app_localizations.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<bool> _onWillPop(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final exit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.navySurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.exitConfirmTitle),
        content: Text(l10n.exitConfirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.exit, style: const TextStyle(color: AppColors.error))),
        ],
      ),
    ) ?? false;
    if (exit) SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: AppColors.navy,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF050D1F), AppColors.navy, Color(0xFF030B18)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [LanguageButton()],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: AppColors.cyan.withOpacity(0.25), blurRadius: 32, spreadRadius: 4)],
                          ),
                          child: ClipOval(
                            child: Image.asset('assets/images/logo.jpg', width: 80, height: 80, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80, height: 80, color: AppColors.navySurface,
                                  child: const Icon(Icons.videocam_rounded, color: AppColors.cyan, size: 40),
                                )),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(l10n.appTitle,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                        const SizedBox(height: 6),
                        Text(l10n.appTagline,
                            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 48),
                        // Customer card
                        _RoleCard(
                          icon: Icons.person_outline_rounded,
                          title: l10n.roleCustomer,
                          subtitle: l10n.roleCustomerSubtitle,
                          accentColor: AppColors.blueAccent,
                          onTap: () => context.push(AppRoutes.customerLogin),
                        ),
                        const SizedBox(height: 16),
                        // Admin card
                        _RoleCard(
                          icon: Icons.admin_panel_settings_rounded,
                          title: l10n.roleAdmin,
                          subtitle: l10n.roleAdminSubtitle,
                          accentColor: AppColors.cyan,
                          isHighlight: true,
                          onTap: () => context.push(AppRoutes.adminLogin),
                        ),
                        const Spacer(),
                        // Footer
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(l10n.appSubTagline,
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final bool isHighlight;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon, required this.title, required this.subtitle,
    required this.accentColor, required this.onTap, this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isHighlight ? null : AppColors.navySurface,
            gradient: isHighlight ? LinearGradient(
              colors: [accentColor.withOpacity(0.15), AppColors.navySurface],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ) : null,
            border: Border.all(color: accentColor.withOpacity(isHighlight ? 0.5 : 0.2), width: 1.5),
            boxShadow: isHighlight ? [BoxShadow(color: accentColor.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))] : [],
          ),
          child: Row(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(0.15),
                  border: Border.all(color: accentColor.withOpacity(0.3)),
                ),
                child: Icon(icon, color: accentColor, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: isHighlight ? accentColor : Colors.white)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: accentColor.withOpacity(0.7), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
