import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/auth/mock_auth.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/language_button.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/secure_scaffold.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/bloc/pin_auth_cubit.dart';

class OwnerSettingsScreen extends StatelessWidget {
  const OwnerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SecureScaffold(
      appBar: AppBar(title: Text(l10n.ownerSettings), actions: const [LanguageButton()]),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Admin info card
          _AdminCard(),
          const SizedBox(height: 24),
          _SectionLabel(l10n.security),
          const SizedBox(height: 12),
          _SettingTile(
            icon: Icons.lock_reset_rounded, color: AppColors.cyan,
            title: l10n.changeOwnerPin,
            onTap: () => _changePin(context),
          ),
          const SizedBox(height: 10),
          _SettingTile(
            icon: Icons.logout_rounded, color: AppColors.error,
            title: l10n.lockOwner,
            onTap: () {
              context.read<PinAuthCubit>().lock();
              MockAuth.logout();
              if (context.mounted) context.go(AppRoutes.roleSelection);
            },
          ),
          const SizedBox(height: 24),
          _SectionLabel(l10n.businessInfoOptional),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.navySurface,
              border: Border.all(color: AppColors.cyan.withOpacity(0.15)),
            ),
            child: Text(l10n.businessInfoHint,
                style: const TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.6)),
          ),
        ],
      ),
    );
  }

  Future<void> _changePin(BuildContext context) async {
    final curCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.navySurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.changeOwnerPin),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: curCtrl, keyboardType: TextInputType.number, obscureText: true, maxLength: 6,
              decoration: InputDecoration(hintText: l10n.currentPin, counterText: '')),
          const SizedBox(height: 10),
          TextField(controller: newCtrl, keyboardType: TextInputType.number, obscureText: true, maxLength: 6,
              decoration: InputDecoration(hintText: l10n.newPin, counterText: '')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.save, style: const TextStyle(color: AppColors.cyan))),
        ],
      ),
    );
    if (ok != true) return;
    final cubit = context.read<PinAuthCubit>();
    final verified = await cubit.verifyPin(curCtrl.text.trim());
    if (!context.mounted) return;
    if (!verified) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.currentPinWrong)));
      return;
    }
    await cubit.setOrChangePin(newCtrl.text.trim());
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pinUpdated)));
  }
}

class _AdminCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: const LinearGradient(colors: [Color(0xFF0D2137), AppColors.navySurface]),
      border: Border.all(color: AppColors.cyan.withOpacity(0.25)),
    ),
    child: Row(children: [
      Container(
        width: 48, height: 48,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.cyan.withOpacity(0.15),
            border: Border.all(color: AppColors.cyan.withOpacity(0.3))),
        child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.cyan, size: 24),
      ),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Ko Phyo Si Thu', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.cyan.withOpacity(0.15)),
          child: const Text('Admin', style: TextStyle(fontSize: 11, color: AppColors.cyan, fontWeight: FontWeight.w600)),
        ),
      ]),
    ]),
  );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5));
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;
  const _SettingTile({required this.icon, required this.color, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.navySurface,
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.15)),
            child: Icon(icon, color: color, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
        Icon(Icons.arrow_forward_ios_rounded, color: color.withOpacity(0.6), size: 14),
      ]),
    ),
  );
}
