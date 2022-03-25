import 'dart:convert';

import 'package:flavor_http/http.dart';
import 'package:flavor_redis_client/src/ledger/ledger_activity.dart';
import 'package:flutter/material.dart';

import '../client_websocket.dart';
import '../main.dart';
import 'client.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                final ActivityPlugin ac = ActivityPlugin();

                ac.getRecent();
              },
              icon: Icon(Icons.bubble_chart))
        ],
      ),
      body: Container(),
    );
  }
}

class ActivityPlugin extends AppPlugin {
  late final WebsocketPlugin ws;

  final List<LedgerActivity> items = [];

  init() {
    print('activity service starting');

    print('not null');
    var ws = WebSocketService();

    // ws.webSocketService.subscribe(
    //   Messenger(
    //       channels: ['activity:user:ID1'],
    //       onData: (data) {
    //         // var d = data.toString().split(',')[0];
    //         // print('Messenger#null: $d');
    //         print('Messenger#null: $data');
    //       }),
    // );
  }

  add(LedgerActivity activity) {
    items.add(activity);
    notifyListeners();
  }

  addAll(Iterable<LedgerActivity> activities) {
    items.addAll(activities);
    notifyListeners();
  }

  Future<List> getRecent() async {
    print('getRecent');
    var data = await fetchJson('http://localhost:8888/activity');
    // var raw = await fetch('http://localhost:8888/activity');
    // var data = json.decode(raw.body);
    print(data['t']);
    return Future.value([]);
  }
}
