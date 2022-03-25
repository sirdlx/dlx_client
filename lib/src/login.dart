import 'package:flavor_auth/flavor_auth.dart';
import 'package:flavor_redis_client/src/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_controller.dart';

class LoginRoute extends StatelessWidget {
  const LoginRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: LoginScreen(
            onLoginEmail: (email, password) async {
              try {
                await auth
                    .login(email: email, password: password)
                    .then((value) async {
                  await Future.delayed(const Duration(seconds: 1));
                  Navigator.of(context).pushReplacementNamed("/dashboard");
                });
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
          ),
        ),
      ),
    );
  }
}
