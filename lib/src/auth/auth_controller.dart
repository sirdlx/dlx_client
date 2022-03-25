import 'package:flavor_redis_client/src/store/store_service.dart';
import 'package:flutter/material.dart';
import 'package:flavor_auth/flavor_auth.dart';

class AuthController with ChangeNotifier {
  AuthController(this.storeService);
  final StoreService storeService;

  Future<void> init() async {
    await loadAuth();
  }

  final AuthEmailHTTPService authService = AuthEmailHTTPService();
  FlavorUser? _user;
  FlavorUser? get user => _user;
  Future<void> loadAuth() async {
    var __user = await storeService.get('user');
    if (__user != null) {
      // print(__user);
      _user = FlavorUser.fromJson(__user);
      notifyListeners();
      return;
    }
    // auth.onUserChange = (userUpdate) async {
    //   print('\n userUpdate \n ${userUpdate?.email}');
    //   _user = userUpdate;
    //   await storeService.put('user', userUpdate?.toJson());
    //   notifyListeners();
    // };
  }

  signUp({
    String? displayName,
    required String email,
    required String password,
    String? phone,
  }) async {
    var __user = await authService.signUpWithEmailAndPassword(
        email: email, password: password);
    _user = FlavorUser.fromMap(__user);
    await storeService.put('user', _user!.toJson());
    notifyListeners();
  }

  login({required String email, required String password}) async {
    var __user = await authService.logInWithEmailAndPassword(
        email: email, password: password);
    _user = FlavorUser.fromMap(__user);
    await storeService.put('user', _user!.toJson());
    notifyListeners();
  }

  Future<bool> logout() async {
    var done = await storeService.delete('user');
    _user = null;
    // var _done = await authService.logout();
    notifyListeners();
    return done;
  }
}
