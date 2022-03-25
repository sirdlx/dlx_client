import 'package:flavor_redis_client/src/ledger/ledger_activity.dart';
import 'package:flavor_redis_client/src/store/store_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:redis/redis.dart';
import 'package:resp_client/resp_client.dart';
import 'package:resp_client/resp_commands.dart';
import 'package:resp_client/resp_server.dart';

import 'ledger_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The LedgerController
/// uses the SettingsService to store and retrieve user settings.
class LedgerController with ChangeNotifier {
  LedgerController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final LedgerService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  late final Store store;
  late final Box<LedgerActivity> noteBox;

  late final RespServerConnection server;
  late RespCommandsTier2 commands;
  late RespClient client;

  Future<bool> loadSettings() async {
    try {
      server = await connectSocket('localhost',
          port: 6379, timeout: const Duration(milliseconds: 300));
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;

    // try {
    //   // _themeMode = await _settingsService.themeMode();
    //   server = await connectSocket('localhost');
    //   client = RespClient(server);

    //   commands = RespCommandsTier2(client);

    //   // final storeItems = store.box().getAll();
    //   // print(storeItems.length);
    //   // final items = await commands.lrange('user:ledger:Casper', 0, 0);
    //   // print(items);

    //   commands.tier1.tier0
    //       .execute('XREAD COUNT 0 STREAMS mystream 0-0'.split(' '))
    //       .then((value) => print('value $value'));
    //   // Important! Inform listeners a change has occurred.
    //   notifyListeners();
    //   return true;
    // } catch (e) {
    //   return Future.error(e);
    // }
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }
}

class LedgerProvider with ChangeNotifier, DiagnosticableTreeMixin {
  RespServerConnection? server;
  late RespCommandsTier2 commands;
  late RespClient client;

  LedgerProvider(this.storeService);
  final StoreService storeService;

  bool? connected;
  ConnectionState state = ConnectionState.none;

  void increment() {
    // _count++;
    notifyListeners();
  }

  Future<bool> init() async {
    state = ConnectionState.waiting;
    notifyListeners();
    try {
      await connect();
      state = ConnectionState.active;
      notifyListeners();

      return true;
    } on Exception {
      state = ConnectionState.none;
      notifyListeners();
      return false;
    }
    // return false;
  }

  String? lastKey;
  RedisConnection mainConnection = RedisConnection();
  RedisConnection subConnection = RedisConnection();
  late Command mainCommand;
  late Command subCommand;
  late PubSub pubsub;
  Future<bool> connect() async {
    // try {
    mainCommand = await mainConnection.connect('localhost', 6379);

    // state = ConnectionState.active;
    // notifyListeners();
    // // } on Exception catch (e) {
    // // if (kDebugMode) {
    // //   print(e);
    // // }
    // // state = ConnectionState.none;
    // // notifyListeners();
    // // return;
    // // }

    // subCommand = await subConnection.connect('localhost', 6379);

    // pubsub = PubSub(mainCommand);

    // pubsub.psubscribe(['__key*__:*']);

    var rr = await mainCommand
        .send_object('XREAD COUNT 0 STREAMS mystream 0-0'.split(' '));
    print(rr);
    return true;

    print('waiting');

    pubsub.getStream().listen((message) async {
      print("message: $message");
      String m = message.toString();
      var g = m.contains('__keyspace@0__:mystream');

      if (g) {
        var rr = await mainCommand.send_object(
            'XREAD BLOCK 0 COUNT 0 STREAMS mystream 0-0'.split(' '));
        if (kDebugMode) {
          // print('rr $rr');
          var r1 = rr as List;
          var r2 = r1[0] as List;
          // print(r2[0]);
        }
      }
    });
  }

  sendWrite() {
    // command.send_object('XADD mystream * field1 value1 field2 value2');
  }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   // properties.add(IterableProperty('count', count));
  // }
}
