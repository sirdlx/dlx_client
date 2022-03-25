import 'package:flavor_redis_client/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_controller.dart';

class MainHome extends StatelessWidget {
  const MainHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController auth = context.watch<AuthController>();
    final ThemePlugin theme = context.watch<ThemePlugin>();
    bool userExist = auth.user != null;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              theme.toggleThemeMode();
            },
            icon: const Icon(Icons.sunny),
          )
        ],
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: 600,
          margin: const EdgeInsets.all(16),
          child: Material(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Material(
                  child: Container(
                    // height: 300,
                    color: Colors.amberAccent,
                  ),
                )),
                // Spacer(),
                ListView(
                  shrinkWrap: true,
                  children: [
                    userExist
                        ? ListTile(
                            onTap: () {},
                            title: Text('${auth.user!.email}'),
                            subtitle: Text('continue'),
                            trailing: ElevatedButton(
                              onPressed: () {},
                              child: Text('Connect'),
                            ),
                          )
                        : Container(),
                  ],
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed("/login");
                      },
                      title: Text('Login'),
                      // subtitle: Text('with Email'),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed("/signup");
                      },
                      title: Text('Signup'),
                      // subtitle: Text('with Email'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
