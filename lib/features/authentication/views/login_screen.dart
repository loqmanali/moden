import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:modn/core/design_system/app_colors/app_colors.dart';
import 'package:modn/core/design_system/theme/moden_theme.dart';
import 'package:modn/core/localization/localization.dart';
import 'package:modn/core/routes/app_navigators.dart';
import 'package:modn/core/utils/app_assets.dart';
import 'package:modn/core/utils/form_validator.dart';
import 'package:modn/core/utils/ui_helper.dart';
import 'package:modn/core/widgets/adaptive_button.dart';
import 'package:modn/core/widgets/app_scaffold.dart';
import 'package:modn/core/widgets/app_spacing.dart';
import 'package:modn/core/widgets/app_text_form_field.dart';
import 'package:modn/core/widgets/body_widget.dart';
import 'package:modn/core/widgets/header_widget.dart';
import 'package:modn/features/authentication/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      header: HeaderLogin(),
      body: BodyLogin(),
    );
  }
}

class HeaderLogin implements Header {
  const HeaderLogin({Key? key});
  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: context.l10n.signIn,
    );
  }
}

class BodyLogin implements Body {
  const BodyLogin({Key? key});
  @override
  Widget build(BuildContext context) {
    return const _LoginBody();
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody();

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null) {
      return;
    }

    if (form.validate()) {
      context.read<LoginCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (!mounted) return;

        if (state is LoginSuccessState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          context.go(AppNavigations.event);
        } else if (state is LoginErrorState) {
          UIHelper.showSnackBar(
            context,
            message: state.error,
            type: SnackBarType.error,
          );
        }
      },
      child: BodyWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSpacing.height(48),
                  Center(child: SvgPicture.asset(AppSvgAssets.logoColor)),
                  const AppSpacing.height(48),
                  Text(
                    '${L10n.email} *',
                    style: context.foruiTheme.typography.xl.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  AppTextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    textColor: AppColors.textPrimary,
                    hintText: L10n.emailPlaceholder,
                    validator: AppFormValidator.instance.validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const AppSpacing.height(24),
                  Text(
                    '${L10n.password} *',
                    style: context.foruiTheme.typography.xl.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  AppTextFormField(
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: '********',
                    obscureText: true,
                    textColor: AppColors.textPrimary,
                    validator: AppFormValidator.instance.validatePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const AppSpacing.height(48),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        final isLoading = state is LoginLoadingState;
                        return AdaptiveButton(
                          onPressed: isLoading ? null : _submit,
                          label: L10n.signIn,
                          labelFontSize: 18,
                          borderRadius: 24,
                          isLoading: isLoading,
                          isDisabled: isLoading,
                          loadingIndicatorColor: AppColors.primary,
                        );
                      },
                    ),
                  ),
                  const AppSpacing.height(24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
