import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/auth/mock_auth.dart';
import '../../../../../core/firebase/fcm_service.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/language_button.dart';
import '../../../../../core/widgets/secure_scaffold.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/bloc/pin_auth_cubit.dart';
import '../bloc/admin_dashboard_cubit.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final List<String> _codes = [];

  @override
  void initState() {
    super.initState();
    FcmService().requestPermission();
    FcmService().registerAsAdmin();
    _codes.addAll(MockAuth.generatedCodes);
  }

  void _generateCode() {
    final code = MockAuth.generateCode();
    setState(() => _codes.add(code));
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$code — ${AppLocalizations.of(context)!.codeCopied}')),
    );
  }

  void _deleteCode(String code) {
    MockAuth.removeCode(code);
    setState(() => _codes.remove(code));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => AdminDashboardCubit()..load(),
      child: SecureScaffold(
        appBar: AppBar(
          title: Text(l10n.ownerDashboard),
          actions: const [LanguageButton()],
        ),
        body: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Welcome
                _WelcomeBanner(),
                const SizedBox(height: 24),
                // Stats grid
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator(color: AppColors.cyan))
                else ...[
                  _SectionTitle('Overview'),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2, shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12, mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _StatCard(label: l10n.totalRequests, value: state.totalRequests.toString(),
                          icon: Icons.all_inbox_rounded, color: AppColors.cyan, onTap: () => context.go(AppRoutes.ownerRequests)),
                      _StatCard(label: l10n.pending, value: state.pendingRequests.toString(),
                          icon: Icons.schedule_rounded, color: AppColors.warning, onTap: () => context.go(AppRoutes.ownerRequests)),
                      _StatCard(label: l10n.installing, value: state.installingRequests.toString(),
                          icon: Icons.build_circle_rounded, color: AppColors.blueAccent, onTap: () => context.go(AppRoutes.ownerRequests)),
                      _StatCard(label: l10n.urgentTickets, value: state.urgentTickets.toString(),
                          icon: Icons.warning_amber_rounded, color: AppColors.error, onTap: () => context.go(AppRoutes.ownerTickets)),
                    ],
                  ),
                ],
                const SizedBox(height: 28),
                // Customer Code Generator
                _SectionTitle(l10n.generateCode),
                const SizedBox(height: 12),
                _CodeGeneratorCard(
                  codes: _codes,
                  onGenerate: _generateCode,
                  onDelete: _deleteCode,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2137), Color(0xFF0F172A)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.cyan.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.cyan.withOpacity(0.15)),
            child: const Icon(Icons.shield_rounded, color: AppColors.cyan, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Secure Plus CCTV', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 3),
              Text(AppLocalizations.of(context)!.installationsCount,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5));
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.navySurface,
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 22),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ]),
      ),
    );
  }
}

class _CodeGeneratorCard extends StatelessWidget {
  final List<String> codes;
  final VoidCallback onGenerate;
  final ValueChanged<String> onDelete;
  const _CodeGeneratorCard({required this.codes, required this.onGenerate, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.navySurface,
        border: Border.all(color: AppColors.cyan.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.key_rounded, color: AppColors.cyan, size: 20),
            const SizedBox(width: 8),
            Text(l10n.generatedCodes, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            const Spacer(),
            GestureDetector(
              onTap: onGenerate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.cyan.withOpacity(0.15),
                  border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
                ),
                child: Row(children: [
                  const Icon(Icons.add_rounded, color: AppColors.cyan, size: 16),
                  const SizedBox(width: 4),
                  Text(l10n.generateCode.split(' ').first, style: const TextStyle(fontSize: 12, color: AppColors.cyan, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          if (codes.isEmpty)
            Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(l10n.noCodesYet, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            ))
          else
            ...codes.map((code) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.navySurfaceAlt,
                border: Border.all(color: AppColors.cyan.withOpacity(0.15)),
              ),
              child: Row(children: [
                const Icon(Icons.circle, color: AppColors.success, size: 8),
                const SizedBox(width: 10),
                Text(code, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 2, color: AppColors.cyan)),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                  icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.textMuted),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.codeCopied)));
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                  onPressed: () => onDelete(code),
                ),
              ]),
            )).toList(),
        ],
      ),
    );
  }
}
