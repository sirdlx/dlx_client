import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
// ignore: unused_import
import 'package:web_socket_channel/status.dart' as status;
// ignore: implementation_imports
import 'package:collection/src/iterable_extensions.dart';

class WebSocketService {
  WebSocketService._();

  // List<_RouteEntry> _routeRegexMap = [];
  // Map<String, dynamic> routeMap = {};
  // get routeRegexMap => <_RouteEntry>[
  //       for (var key in routeMap.keys) _buildRouteEntry(key),
  //     ];

  // generateRoute(dynamic message) {
  //   final routeName = _cleanRouteName(message);

  //   RegExpMatch? match;
  //   final routeEntry = _routeRegexMap.firstWhereOrNull((it) {
  //     match = it.regex.firstMatch(routeName);
  //     return match != null;
  //   });

  //   if (routeEntry == null) return null;

  //   List<String> names;

  //   if (match != null &&
  //       match!.groupCount > 0 &&
  //       match!.groupNames.isNotEmpty) {
  //     names = match!.groupNames.toList();
  //   } else {
  //     names = [];
  //   }

  //   final pathArgs = <String, String?>{
  //     for (var name in names) name: match?.namedGroup(name),
  //   };

  //   // return MaterialPageRoute(
  //   //   settings: settings,
  //   //   builder: (context) => routeEntry.routeBuilder(
  //   //     context,
  //   //     RouteArgs(pathArgs, settings.arguments),
  //   //   ),
  //   // );
  // }

  static final WebSocketService _instance = WebSocketService._();

  factory WebSocketService() => _instance;
  instance() => _instance;
  // static get instance => _instance;
  late final IOWebSocketChannel socketChannel;

  Future<bool> init() async {
    if (kDebugMode) {
      print('WebSocketService init');
    }
    try {
      socketChannel = IOWebSocketChannel.connect(
        'ws://localhost:8888',
        headers: {'userID': 'ID1'},
      );
      socketChannel.stream.listen(processIncoming);

      return true;
    } catch (e) {
      return false;
    }
  }

  List<Messenger> subscribers = [];

  processIncoming(dynamic message) {
    print('processIncoming::message \n $message');
    // var route = (message as String).split(' ')[0];
    // var body = message.split(route)[1];
    for (var messenger in subscribers) {
      for (var channel in messenger.channels) {
        if (message.contains(channel)) {
          messenger.onData(message);
        }
      }
    }
  }

  Future<dynamic> get(String key) async {
    socketChannel.sink.add('GET $key');
  }

  Future<void> set(String key, String value) async {
    // print('SET $key');
    socketChannel.sink.add('SET $key $value');
  }

  // Pub/Sub

  Future<void> publish(String channel, String message) async {
    socketChannel.sink.add('PUBLISH $channel $message');
    // await command.("demo.redis", "Hello World");
  }

  Future<void> subscribe(Messenger messenger) async {
    // print(messenger.channels.join(' '));
    subscribers.add(messenger);
    send('PSUBSCRIBE ${messenger.channels.join(' ')}');
  }

  Future<void> send(String data) async {
    print('SENDING DATA :: ${data.split(' ')}');
    socketChannel.sink.add(data);
  }

  unsunscribe(List<String> channels) {}

  // Pipelining
  initPipeline() {
    // client.pipeline();
  }

  flushPipeline() {
    // client.flush();
  }

  disconnect() async {}
}

class Messenger {
  final Function(dynamic data) onData;
  Messenger({
    required this.channels,
    required this.onData,
  });

  final List<String> channels;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Messenger && other.onData == onData;
  }

  @override
  int get hashCode => hashCode + onData.hashCode;
}

class _RouteEntry {
  final String name;
  final RegExp regex;

  _RouteEntry(
    this.name,
    this.regex,
  );

  @override
  int get hashCode => runtimeType.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _RouteEntry &&
          runtimeType == other.runtimeType &&
          name == other.name;
}

_RouteEntry _buildRouteEntry(String name) {
  final cleanRouteName = _cleanRouteName(name);
  const variableRegex = '[a-zA-Z0-9_-]+';
  final nameWithParameters = cleanRouteName.replaceAllMapped(
    RegExp(":($variableRegex)"),
    (match) {
      final groupName = match.group(1);
      return "(?<$groupName>[a-zA-Z0-9_\\\-\.,:;\+*^%\$@!]+)";
    },
  );
  final regex = RegExp("^$nameWithParameters\$", caseSensitive: false);
  return _RouteEntry(name, regex);
}

String _cleanRouteName(String name) {
  name = name.trim();
  final parts = name.split("/");
  parts.removeWhere((value) => value == "");
  parts.map((value) {
    if (value.startsWith(":")) {
      return value;
    } else {
      return value.toLowerCase();
    }
  });
  name = parts.join("/");
  return name;
}
