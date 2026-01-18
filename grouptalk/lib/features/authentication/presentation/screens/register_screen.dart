import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grouptalk/core/core/Route/route_name.dart';
import 'package:grouptalk/core/theme/app_colors.dart';
import 'package:grouptalk/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:grouptalk/features/authentication/presentation/widgets/divider.dart';
import 'package:grouptalk/features/authentication/presentation/widgets/google_button.dart';
import 'package:grouptalk/features/authentication/presentation/widgets/input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    context.read<AuthBloc>().add(
      RegisterWithEmailEvent(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.goNamed(RouteName.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.primary,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Join AI Study Rooms',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Start your learning journey today',
                    style: TextStyle(color: AppColors.textLight),
                  ),

                  const SizedBox(height: 32),

                  inputField(
                    controller: _fullNameController,
                    hint: 'Full Name',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 16),

                  inputField(
                    controller: _emailController,
                    hint: 'Email',
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 16),

                  inputField(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    obscure: true,
                  ),

                  const SizedBox(height: 24),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state is AuthLoading
                              ? const CircularProgressIndicator()
                              : const Text('Login'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  divider(),
                  const SizedBox(height: 16),

                  googleBotton(text: 'Sign up with Google'),

                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => context.goNamed(RouteName.login),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // child: Scaffold(
      //   appBar: AppBar(title: const Text('Register')),
      //   body: Padding(
      //     padding: const EdgeInsets.all(16),
      //     child: Column(
      //       children: [
      //         TextField(
      //           controller: _emailController,
      //           decoration: const InputDecoration(labelText: 'Email'),
      //         ),
      //         const SizedBox(height: 12),
      //         TextField(
      //           controller: _passwordController,
      //           obscureText: true,
      //           decoration: const InputDecoration(labelText: 'Password'),
      //         ),
      //         const SizedBox(height: 24),
      //         BlocBuilder<AuthBloc, AuthState>(
      //           builder: (context, state) {
      //             return state is AuthLoading
      //                 ? const CircularProgressIndicator()
      //                 : ElevatedButton(
      //                     onPressed: _register,
      //                     child: const Text('Register'),
      //                   );
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
