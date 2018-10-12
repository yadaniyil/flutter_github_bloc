import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_github_bloc/api/auth_repo.dart';
import 'package:flutter_github_bloc/models/user.dart';

class UserRepo {

  final AuthRepo _authRepo;
  final String _username;

  UserRepo(this._authRepo, this._username);

  Future<User> loadUser() async {
    var oauthClient = _authRepo.oauthClient;
    var response = await http
        .get('https://api.github.com/users/$_username')
        .whenComplete(oauthClient.close);

    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      return User.fromJson(decoded);
    } else {
      throw Exception('Could not get current user');
    }
  }
}