import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Normalize phone for tel: (digits only; leading + allowed).
String _normalizeTel(String phone) {
  final digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
  if (digits.startsWith('0')) {
    return '+95${digits.substring(1)}';
  }
  if (!digits.startsWith('+')) {
    return '+$digits';
  }
  return digits;
}

Future<void> launchTel(BuildContext context, String phone) async {
  final normalized = _normalizeTel(phone);
  final uri = Uri(scheme: 'tel', path: normalized);
  final launched = await _safeLaunch(context, uri);
  if (!launched) {
    _showError(context, 'Could not launch phone dialer.');
  }
}

Future<void> launchUrlString(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    _showError(context, 'Invalid URL.');
    return;
  }
  final launched = await _safeLaunch(context, uri);
  if (!launched) {
    _showError(context, 'Could not open link.');
  }
}

Future<void> launchEmail(BuildContext context, String email) async {
  final uri = Uri(scheme: 'mailto', path: email);
  final launched = await _safeLaunch(context, uri);
  if (!launched) {
    _showError(context, 'Could not open email app.');
  }
}

/// Try to launch; for custom schemes (weixin, viber, etc.) we don't rely on
/// canLaunchUrl as it often returns false even when the app can open.
Future<bool> _safeLaunch(BuildContext context, Uri uri) async {
  try {
    final isCustomScheme = !{'http', 'https', 'tel', 'mailto'}.contains(uri.scheme);
    if (isCustomScheme) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }
  } catch (_) {
    // Fallback: try launch anyway (e.g. tel/mailto on some platforms)
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    } catch (_) {}
  }
  return false;
}

void _showError(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) {
    return;
  }

  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

