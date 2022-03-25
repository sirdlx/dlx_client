import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:regex_router/regex_router.dart';

// ignore: must_be_immutable
class DLXApp extends StatelessWidget {
  const DLXApp({
    Key? key,
    required this.routes,
    required this.entry,
    this.plugins = const [],
    this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext, Widget?)? builder;

  @override
  Widget build(BuildContext context) {
    List<SingleChildWidget> pluginsList = plugins!.map((e) {
      return e;
    }).toList();

    return MultiProvider(
      providers: pluginsList,
      builder: (context, _) {
        // return builder(routes);
        return entry(RegexRouter.create(routes).generateRoute);
      },
    );
  }

  final Map<String, Widget Function(BuildContext, RouteArgs)> routes;

  final DLXAppEntry Function(
      Route<dynamic>? Function(RouteSettings settings) generateRoute) entry;

  get router => RegexRouter.create(routes);

  final List<SingleChildWidget>? plugins;
}

abstract class DLXAppEntry extends StatelessWidget {
  const DLXAppEntry({Key? key}) : super(key: key);
}

abstract class AppPlugin extends ChangeNotifier {
  AppPlugin();
}
