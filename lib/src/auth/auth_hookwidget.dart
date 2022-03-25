import 'package:flavor_auth/flavor_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AuthHookWidget extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    FlavorUser user,
  ) // FirebaseAuthRepository controller)
      builder;

  const AuthHookWidget({required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<FlavorUser>();
    return Builder(
      builder: (context) => builder(context, user),
    );
  }
}
