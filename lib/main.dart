import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/locale/locale_cubit.dart';
import 'core/notification/app_notification_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/pin_auth_cubit.dart';
import 'features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'l10n/app_localizations.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Channel is created at app startup; FCM will show notification with that channel.
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Create "default" channel so FCM notifications show as popup with sound (Android 8+).
  final notificationService = AppNotificationService();
  await notificationService.initialize();

  // Foreground: show local notification when FCM message arrives.
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    notificationService.showFromFcm(message);
  });

  await Hive.initFlutter();
  await Hive.openBox('secure_plus_settings');

  // ✅ Create cubits once, then inject into AppRouter + BlocProvider.value
  final onboardingCubit = OnboardingCubit()..loadStatus();
  final pinAuthCubit = PinAuthCubit()..ensureDefaultPinSeeded();

  final GoRouter router = AppRouter(
    onboardingCubit: onboardingCubit,
    pinAuthCubit: pinAuthCubit,
  ).router;

  final localeCubit = LocaleCubit();

  runApp(
    SecurePlusApp(
      router: router,
      onboardingCubit: onboardingCubit,
      pinAuthCubit: pinAuthCubit,
      localeCubit: localeCubit,
    ),
  );
}

class SecurePlusApp extends StatelessWidget {
  const SecurePlusApp({
    super.key,
    required this.router,
    required this.onboardingCubit,
    required this.pinAuthCubit,
    required this.localeCubit,
  });

  final GoRouter router;
  final OnboardingCubit onboardingCubit;
  final PinAuthCubit pinAuthCubit;
  final LocaleCubit localeCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: onboardingCubit),
        BlocProvider.value(value: pinAuthCubit),
        BlocProvider.value(value: localeCubit),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        buildWhen: (prev, next) => prev != next,
        builder: (context, locale) {
          return MaterialApp.router(
            title: 'Secure Plus',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.dark,
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
