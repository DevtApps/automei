import 'dart:convert';

import 'package:automei/app/provider/AppStatus.dart';
import 'package:automei/fastfire/models/UserStateModel.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../Api.dart';

class SubscriptionController with UserStateModel {
  var context;
  SubscriptionController(this.context);

  Future<Map<String, dynamic>?> createSubscription(id) async {
    try {
      final url = Uri.parse('$URL/create-subscription');
      final response = await post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': await auth.currentUser!.getIdToken()
        },
        body: json.encode({
          'customerId': id,
        }),
      );
      if (response.statusCode == 200)
        return json.decode(response.body);
      else
        throw new Exception();
    } catch (e) {
      Provider.of<AppStatus>(context, listen: false).setStatusSubscription(0);
      return null;
    }
  }

  Future<void> statusSubscription() async {
    try {
      final url = Uri.parse('$URL/subscription-status');
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': await auth.currentUser!.getIdToken()
        },
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        Provider.of<AppStatus>(context, listen: false)
            .setStatusSubscription(json['status']);
      } else
        throw new Exception();
    } catch (e) {
      Provider.of<AppStatus>(context, listen: false).setStatusSubscription(0);
    }
  }

  Future<bool> cancelSubscription() async {
    try {
      final url = Uri.parse('$URL/subscription-cancel');

      final response = await post(
        url,
        headers: {'token': await auth.currentUser!.getIdToken()},
      );
      switch (response.statusCode) {
        case 200:
          {
            return true;
          }
        case 400:
          {
            return false;
          }
        default:
          return false;
      }
    } catch (e) {
      print(e);

      return false;
    }
  }
}
