import 'package:flavor_http/http.dart';
import 'package:flavor_redis_client/client_websocket.dart';
import 'package:flavor_redis_client/main.dart';
import 'package:flavor_redis_client/src/activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flavor_ui/flavor_ui.dart' as fui;
import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  late final WebSocketService ws;
  @override
  void initState() {
    init();

    super.initState();
  }

  final ActivityPlugin ac = ActivityPlugin();

  bool? connected;
  init() async {
    // print('init');
    // ws = WebSocketService();
    // connected = await ws.init();
    // print('Connected : $connected');
    // setState(() {});
    // if (connected != null && connected == true) {
    var activitiesJson = await ac.getRecent();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // return loadingWidget;

    // var ws = context.watch<WebsocketPlugin>();

    return FutureBuilder(
      // future: ws.webSocketService.init(),
      future: Future.value(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return fui.ResponsiveView(
            breakpoints: {
              fui.DisplayType.m: Scaffold(
                appBar: AppBar(
                  elevation: 1,
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.wrap_text_rounded),
                    )
                  ],
                ),
                drawer: DrawerMenu(),
                body: Container(
                  color: Colors.deepOrange,
                  child: ListView(
                    children: List.generate(
                      20,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 100,
                          child: fui.CardTile(
                            onTap: () {},
                            headerTitle: 'Title',
                            footerTitle: 'Footer',
                            body: Material(
                              color: Colors.black12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            },
          );
        }
        return loadingWidget;
      },
    );
  }
}

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Material(
        color: Colors.deepOrangeAccent,
        child: Container(
          alignment: Alignment.topCenter,
          width: 200,
          height: double.infinity,
          child: Column(
            children: [
              Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .restorablePopAndPushNamed('/activity');
                    },
                    title: Text('Activity'),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .restorablePopAndPushNamed('/account');
                    },
                    title: Text('Account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const loadingWidget = Scaffold(body: CenterLoading());

class CenterLoading extends StatelessWidget {
  const CenterLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
