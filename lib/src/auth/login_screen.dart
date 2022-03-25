import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  final Function(String email, String password) onLoginEmail;

  const LoginScreen({
    Key? key,
    required this.onLoginEmail,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _password = "Rocky0813!";
  String? _email = 'sirwhite@dlxstudios.com';

  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    _submit() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _busy = true;
        });
        await Future.delayed(const Duration(seconds: 0));

        await widget.onLoginEmail(_email!, _password!);

        // .onError((error, stackTrace) {
        //   // print('error::$error');
        //   ScaffoldMessenger.of(context)
        //       .showSnackBar(SnackBar(content: Text('$error')));
        setState(() {
          _busy = false;
        });
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: TextFormField(
              enabled: !_busy,
              initialValue: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (input) {
                return input == null || input.isEmpty || !input.contains('@')
                    ? 'Please enter a valid email'
                    : null;
              },
              onSaved: (input) => _email = input,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: TextFormField(
              enabled: !_busy,
              initialValue: _password,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (input) =>
                  input!.length < 6 ? 'Must be at least 6 characters' : null,
              onFieldSubmitted: (input) => _password = input,
              obscureText: true,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: !_busy ? _submit : null,
                child: const Text(
                  'Forgot Password?',
                ),
              ),
              ElevatedButton(
                onPressed: !_busy ? _submit : null,
                child: const Text(
                  'Login',
                ),
              ),
            ],
          ),

          // SizedBox(height: 20.0),
          // ElevatedButton(
          //   onPressed: () => Navigator.pushNamed(context, SignupScreen.id),
          //   child: Text(
          //     'Sign up',
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SignupView extends StatefulWidget {
  static const String id = 'signup_screen';
  final Function(dynamic email, dynamic pass, dynamic pass2) onEmailSignup;
  const SignupView({
    Key? key,
    required this.onEmailSignup,
  }) : super(key: key);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();

  String? password = "Rocky0813!";
  String? password2 = "Rocky0813!";
  String? email = "sirwhite@dlxstudios.com";
  String? displayName = 'sir white';
  String? phoneNumber = '9094879111';

  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    _submit() async {
      setState(() {
        _busy = true;
      });
      await Future.delayed(const Duration(seconds: 1));

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        await widget.onEmailSignup(email!, password!, password2!);
      }
      // await Future.delayed(Duration(seconds: 5));

      setState(() {
        _busy = false;
      });
    }

    return Column(
      children: [
        _busy == true ? const LinearProgressIndicator() : Container(),
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: TextFormField(
                  enabled: !_busy == true,
                  initialValue: displayName,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (input) => input!.trim().isEmpty
                      ? 'Please enter a valid name'
                      : null,
                  onSaved: (input) => displayName = input,
                  autofocus: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: TextFormField(
                  enabled: !_busy == true,
                  initialValue: phoneNumber,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (input) => input == null
                      ? 'Please enter a valid phone number'
                      : null,
                  onSaved: (input) => phoneNumber = input,
                  autofocus: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: TextFormField(
                  enabled: !_busy == true,
                  initialValue: email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (input) {
                    return input == null ||
                            input.isEmpty ||
                            !input.contains('@')
                        ? 'Please enter a valid email'
                        : null;
                  },
                  onSaved: (input) => email = input,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: TextFormField(
                  enabled: !_busy == true,
                  initialValue: password,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (input) => input!.length < 6
                      ? 'Must be at least 6 characters'
                      : null,
                  onSaved: (input) => password = input!,
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: TextFormField(
                  enabled: !_busy == true,

                  initialValue: password2,
                  decoration:
                      const InputDecoration(labelText: 'Renter Password'),
                  validator: (input) {
                    // ignore: avoid_print
                    print(password2);
                    return input == null || input != password
                        ? 'Passwords do not match'
                        : null;
                  },
                  // onSaved: (input) => _password = input!,
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // TextButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   child: Text(
                  //     'Back to Login',
                  //   ),
                  // ),
                  ElevatedButton(
                    onPressed: _busy != true ? _submit : null,
                    child: const Text(
                      'Sign Up',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ],
    );
  }
}
