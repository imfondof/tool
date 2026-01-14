import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bootstrap/di/service_locator.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Login failed')),
            );
          } else if (state.status == LoginStatus.success) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Sign in')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      label: state.status == LoginStatus.loading
                          ? 'Signing in...'
                          : 'Sign in',
                      onPressed: state.status == LoginStatus.loading
                          ? null
                          : () {
                              context.read<LoginBloc>().add(
                                    LoginSubmitted(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
