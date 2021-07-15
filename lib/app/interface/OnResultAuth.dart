import 'package:firebase_auth/firebase_auth.dart';

class OnResult {
  void onError(Exception? e, int code) {}
  void onSuccess(UserCredential? user) {}
}
