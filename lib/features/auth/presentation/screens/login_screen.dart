import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/mock_auth.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/language_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/pin_auth_cubit.dart';

// ─── Customer Login ───────────────────────────────────────────────────────────
class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});
  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final _codeCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  void _login() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 600));
    final ok = MockAuth.loginWithCode(code);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      context.go(AppRoutes.customerServices);
    } else {
      setState(() => _error = AppLocalizations.of(context)!.invalidCode);
    }
  }

  @override
  void dispose() { _codeCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => context.pop()),
                    const LanguageButton(),
                  ],
                ),
                const SizedBox(height: 24),
                // Icon
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.blueAccent.withOpacity(0.15),
                    border: Border.all(color: AppColors.blueAccent.withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.person_rounded, color: AppColors.blueAccent, size: 32),
                ),
                const SizedBox(height: 20),
                Text(l10n.loginTitle, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                Text(l10n.loginSubtitle, style: const TextStyle(fontSize: 14, color: AppColors.textMuted)),
                const SizedBox(height: 40),
                // Code field
                _Label('Access Code'),
                const SizedBox(height: 8),
                TextField(
                  controller: _codeCtrl,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2, color: AppColors.cyan),
                  decoration: InputDecoration(
                    hintText: l10n.accessCodeHint,
                    prefixIcon: const Icon(Icons.vpn_key_rounded, color: AppColors.blueAccent),
                    errorText: _error,
                  ),
                  onSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 32),
                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                        : Text(l10n.loginButton, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text('Secure Plus CCTV · ${l10n.since2016}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Admin Login ──────────────────────────────────────────────────────────────
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  void _login() async {
    final u = _userCtrl.text.trim();
    final p = _passCtrl.text;
    if (u.isEmpty || p.isEmpty) return;
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 700));
    final user = MockAuth.loginAdmin(u, p);
    if (!mounted) return;
    setState(() => _loading = false);
    if (user != null) {
      context.read<PinAuthCubit>().unlockByLogin();
      context.go(AppRoutes.ownerDashboard);
    } else {
      setState(() => _error = AppLocalizations.of(context)!.wrongCredentials);
    }
  }

  @override
  void dispose() { _userCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => context.pop()),
                    const LanguageButton(),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.cyan.withOpacity(0.15),
                    border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.cyan, size: 32),
                ),
                const SizedBox(height: 20),
                Text(l10n.adminLoginTitle, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                Text(l10n.adminLoginSubtitle, style: const TextStyle(fontSize: 14, color: AppColors.textMuted)),
                const SizedBox(height: 40),
                _Label(l10n.usernameHint),
                const SizedBox(height: 8),
                TextField(
                  controller: _userCtrl,
                  decoration: InputDecoration(
                    hintText: l10n.usernameHint,
                    prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(height: 16),
                _Label(l10n.passwordHint),
                const SizedBox(height: 8),
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: l10n.passwordHint,
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppColors.textMuted),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    errorText: _error,
                  ),
                  onSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                        : Text(l10n.loginButton, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text('Authorized personnel only',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.5));
}
