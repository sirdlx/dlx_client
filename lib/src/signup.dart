import 'package:flavor_redis_client/src/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_controller.dart';

class SignUpRoute extends StatelessWidget {
  const SignUpRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SignupView(
              onEmailSignup: (email, password, password2) async =>
                  onEmailSignup(email, password, context)),
        ),
      ),
    );
  }

  Future<void> onEmailSignup(email, password, BuildContext context) async {
    final AuthController auth = context.watch<AuthController>();
    try {
      await auth.signUp(email: email, password: password).then((value) {
        // Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed("/dashboard");
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
