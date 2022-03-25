import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';

class StoreService {
  late final Box box;

  Future<bool> put(key, value) async {
    await box.put(key, value);
    return true;
  }

  Future<dynamic> get(key) async {
    return await box.get(key);
  }

  Future<bool> delete(key) async {
    await box.delete(key);
    return true;
  }

  Future<Box> init<E>(
    String name, {
    HiveCipher? encryptionCipher,
    bool crashRecovery = true,
    String? path,
    Uint8List? bytes,
  }) async {
    var path = Directory.current.path;
    Hive.init(path);
    box = await Hive.openBox<E>(
      name,
      encryptionCipher: encryptionCipher,
      crashRecovery: crashRecovery,
      path: path,
      bytes: bytes,
    );
    return box;
  }
}
