import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:food_delivery_app/features/auth/presentation/widgets/custom_auth_appbar.dart';
import 'package:food_delivery_app/features/auth/presentation/widgets/forgot_password_button.dart';
import 'package:food_delivery_app/features/auth/presentation/widgets/sign_up_textbutton.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/fingerprint_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await ref.read(authControllerProvider.notifier).login(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
          );

      if (!mounted) return;

      context.go(RouteNames.home);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to log in. Check your credentials and try again.',
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email or mobile number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.headerYellow,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.headerYellow,
        body: Column(
          children: [
            CustomAuthAppBar(topInset: topInset),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
                child: Container(
                  width: double.infinity,
                  color: AppColors.background,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        // padding: const EdgeInsets.symmetric(horizontal: 31),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // const SizedBox(height: 23),
                                    const Text(
                                      'Welcome',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 35),
                                    AuthTextField(
                                      label: 'Email or Mobile Number',
                                      controller: _usernameController,
                                      hintText: 'example@example.com',
                                      validator: _validateUsername,
                                    ),
                                    const SizedBox(height: 14),
                                    AuthTextField(
                                      label: 'Password',
                                      controller: _passwordController,
                                      hintText: 'Enter your password',
                                      isPassword: true,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) => _login(),
                                      validator: _validatePassword,
                                    ),
                                    ForgotPasswordButton(),
                                    const Spacer(),
                                    Center(
                                      child: AppPrimaryButton(
                                        label: 'Log In',
                                        isLoading: _isSubmitting,
                                        onPressed: _login,
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    const Center(
                                      child: Text(
                                        'or',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 9),
                                    const Center(
                                      child: FingerprintButton(),
                                    ),
                                    const SizedBox(height: 21),
                                   const SignUpTextbutton(),
                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
