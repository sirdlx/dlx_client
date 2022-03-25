// import 'package:objectbox/objectbox.dart';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flavor_redis_client/src/activity_screen.dart';
import 'package:flavor_redis_client/src/auth/auth_controller.dart';
import 'package:flavor_redis_client/src/client.dart';
import 'package:flavor_redis_client/src/dashboard.dart';
import 'package:flavor_redis_client/src/login.dart';
import 'package:flavor_redis_client/src/signup.dart';
import 'package:flavor_redis_client/src/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flavor_redis_client/src/store/store_service.dart';
// ignore: implementation_imports
import 'package:bitsdojo_window/src/app_window.dart';
import 'package:provider/provider.dart';
import 'package:regex_router/src/route_args.dart';
import 'package:url_strategy/url_strategy.dart';

import 'client_websocket.dart';
import 'src/account_screen.dart';
import 'src/home.dart';

late final StoreService storeService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    setPathUrlStrategy();
  }

  storeService = StoreService();
  await storeService.init('app_name');
  var window = await storeService.get('window_size');
  // print(window);

  doWhenWindowReady(() {
    final win = appWindow;

    // var initialSize = const Size(600, 450);
    // win.minSize = initialSize;
    // win.size = initialSize;

    win.title = "Gmae on!";
    win.show();
  });

  runApp(
    DLXApp(
      plugins: [
        ChangeNotifierProvider(create: (_) => ThemePlugin(storeService)),
        // ChangeNotifierProvider(create: (_) => WebsocketPlugin()),
        ChangeNotifierProvider<ActivityPlugin>(create: (_) => ActivityPlugin()),
        ChangeNotifierProvider<AuthController>(
            create: (_) => AuthController(storeService))
      ],
      entry: (routes) => AppShell(routes),
      routes: {
        '/': (p0, p1) => const MainHome(),
        '/dashboard': (p0, p1) => const DashboardWidget(),
        '/activity': (p0, p1) => const ActivityScreen(),
        '/account': (p0, p1) => const AccountScreen(),
        '/login': (p0, p1) => const LoginRoute(),
        '/signup': (p0, p1) => const SignUpRoute(),
      },
    ),
  );
}

class WebsocketPlugin extends AppPlugin {
  final WebSocketService webSocketService = WebSocketService();
}

class ThemePlugin extends AppPlugin {
  final StoreService store;

  ThemePlugin(this.store);

  late ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    await storeService.put('themeMode', _themeMode.toString());
    notifyListeners();
  }

  Future<void> toggleThemeMode() async {
    // print(_themeMode);
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.system;
    } else if (_themeMode == ThemeMode.system) {
      _themeMode = ThemeMode.dark;
    }
    // print(_themeMode);

    await storeService.put('themeMode', _themeMode.toString());
    // print(done);
    notifyListeners();
  }

  void updateAndSave() {
    // print('updateAndSave()::_themeMode::$_themeMode');
    // appBox!.put('_user', user != null ? user!.toJson() : null);

    notifyListeners();
  }

  Future<void> loadAppSettingsFromDisk() async {
    //
    String? __themeMode = await storeService.get('themeMode');
    // print('__themeMode \n $__themeMode');
    if (__themeMode != null) {
      if (__themeMode == "ThemeMode.dark") {
        _themeMode = ThemeMode.dark;
      } else if (__themeMode == "ThemeMode.light") {
        _themeMode = ThemeMode.light;
      } else if (__themeMode == "ThemeMode.system") {
        _themeMode = ThemeMode.system;
      }
    }
  }
}

class AppService with ChangeNotifier {
  final GlobalKey<NavigatorState> globalNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();
}

class AppShell extends DLXAppEntry {
  final Route<dynamic>? Function(RouteSettings settings) generateRoute;
  const AppShell(this.generateRoute, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themePlugin = context.watch<ThemePlugin>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: AddScrollBehavior(),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.orangeAccent,
        backgroundColor: Colors.grey.shade900,
        scaffoldBackgroundColor: Colors.grey.shade900,
      ),
      themeMode: themePlugin.themeMode,
      onGenerateRoute: generateRoute,
      // routes: app.,
    );
  }
}

// class AppShell extends StatelessWidget {
//   const AppShell({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//         animation: app,
//         builder: (context, _) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             scrollBehavior: AddScrollBehavior(),
//             darkTheme: ThemeData.dark().copyWith(
//               primaryColor: Colors.orangeAccent,
//               backgroundColor: Colors.grey.shade900,
//               scaffoldBackgroundColor: Colors.grey.shade900,
//             ),
//             themeMode: app.themeMode,
//             home: MainHome(app),

//             routes: app.,
//           );
//         });
//   }
// }
