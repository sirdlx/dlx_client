import 'dart:async';

import 'package:flavor_auth/flavor_auth.dart';

// class AuthService {
//   Future<void> signOut() async {
//     try {} catch (e) {
//       throw CustomException(message: e.toString());
//     }
//   }

//   Future<FlavorUser> signUpWithEmailAndPassword({
//     required String displayName,
//     required String email,
//     required String password,
//   }) async {
//     return await auth_service
//         .createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     )
//         .onError((error, stackTrace) {
//       if (error.toString().contains('email-already-in-use')) {
//         return Future.error('Email "$email" is already in use. ');
//       }
//       return Future.error(error!);
//     });
//   }

//   Future<FlavorUser> logInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     return await fbAuth
//         .signInWithEmailAndPassword(email: email, password: password)
//         .then((value) {
//       return FirebaseFirestore.instance
//           .doc('/users/${value.user!.email}')
//           .get();
//     }).then((DocumentSnapshot<Map<String, dynamic>> userJson) {
//       var data = userJson.data();
//       // print('data::$data');

//       if (data == null) {
//         return Future.error({'message': 'No user data'});
//       }
//       return FlavorUser(
//         displayName: data['display_name'],
//         email: data['email'],
//         emailVerified: data['emailVerified'],
//         localId: data['localId'],
//       );
//     });
//   }

//   Future<FlavorUser> loginFromFBCache({
//     required User user,
//   }) async {
//     if (user.isAnonymous) {
//       return FlavorUser(
//         email: user.email,
//         isAnonymous: true,
//         localId: user.uid,
//         refreshToken: user.refreshToken,
//       );
//     }

//     return firestore
//         .doc('/users/${user.email}')
//         .get()
//         .then((DocumentSnapshot<Map<String, dynamic>> userJson) {
//       var data = userJson.data();
//       // print('data::$data');

//       if (data == null) {
//         return Future.error({'message': 'No user data'});
//       }
//       return FlavorUser(
//         email: user.email,
//         emailVerified: user.emailVerified,
//         localId: user.uid,
//         phoneNumber: data['phone_number'],
//         displayName: data['display_name'],
//         refreshToken: user.refreshToken,
//       );
//     });
//   }
// }

class CustomException implements Exception {
  final String? message;

  const CustomException({this.message = 'Something went wrong!'});

  @override
  String toString() => 'CustomException { message: $message }';
}
