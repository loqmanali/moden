import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/routes/app_navigators.dart';
import 'package:modn/core/services/di.dart';
import 'package:modn/core/widgets/adaptive_button.dart';
import 'package:modn/core/widgets/app_spacing.dart';
import 'package:modn/features/authentication/cubit/login_cubit.dart';

import '../../core/localization/localization.dart';
import '../../core/utils/app_assets.dart';
import '../../core/utils/app_system_ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    // Wait a bit for splash animation
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check if auto-login is enabled and user is logged in
    final loginCubit = di<LoginCubit>();
    final isLoggedIn = await loginCubit.checkAutoLogin();

    if (!mounted) return;

    if (isLoggedIn) {
      // User is already logged in, navigate to main screen
      context.go(AppNavigations.event);
    }
    // Otherwise, stay on splash screen and let user click "Get Started"
  }

  @override
  Widget build(BuildContext context) {
    AppSystemUi.setSystemUIWithoutContext(isDark: true);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(AppAssets.bg, fit: BoxFit.fill),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSpacing.height(context.height * 0.2),
              SvgPicture.asset(
                AppSvgAssets.logoWhite,
                fit: BoxFit.cover,
              ),
              const AppSpacing.height(48),
              Text(
                L10n.appTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const AppSpacing.height(18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  L10n.appDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              const AppSpacing.height(32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: AdaptiveButton(
                  onPressed: () {
                    context.go(AppNavigations.login);
                  },
                  label: L10n.getStarted,
                  borderRadius: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
