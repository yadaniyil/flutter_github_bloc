import 'dart:async';
import 'dart:convert';
import 'package:flutter_github_bloc/keys.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  static const String KEY_USERNAME = 'KEY_USERNAME';
  static const String KEY_OAUTH_TOKEN = 'KEY_AUTH_TOKEN';

  final String _clientId = CLIENT_ID;
  final String _clientSecret = CLIENT_SECRET;
  final Client _client = Client();
  OauthClient _oauthClient;

  OauthClient get oauthClient => _oauthClient;

  Future<bool> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(KEY_USERNAME);
    String oauthToken = prefs.getString(KEY_OAUTH_TOKEN);

    if (username == null || oauthToken == null) {
      await logout();
      return false;
    } else {
      _oauthClient = OauthClient(_client, oauthToken);
      return true;
    }
  }

  Future<bool> login(String username, String password) async {
    var basicToken = _getEncodedAuthorization(username, password);
    final requestHeader = {'Authorization': 'Basic $basicToken'};
    final requestBody = json.encode({
      'client_id': _clientId,
      'client_secret': _clientSecret,
      'scopes': ['user']
    });

    final loginResponse = await Client()
        .post('https://api.github.com/authorizations',
            headers: requestHeader, body: requestBody)
        .whenComplete(_client.close);

    print('Response body: ${loginResponse.body}');

    if (loginResponse.statusCode == 201) {
      final bodyJson = json.decode(loginResponse.body);
      await _saveTokens(username, bodyJson['token']);
      return true;
    } else {
      return false;
    }
  }

  Future<String> getSavedUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_USERNAME);

  }

  Future logout() async {
    await _saveTokens(null, null);
  }

  String _getEncodedAuthorization(String username, String password) {
    final authorizationBytes = utf8.encode('${username}:${password}');
    return base64.encode(authorizationBytes);
  }

  Future _saveTokens(String username, String oauthToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY_USERNAME, username);
    prefs.setString(KEY_OAUTH_TOKEN, oauthToken);
    await prefs.commit();
    _oauthClient = OauthClient(_client, oauthToken);
  }
}

class OauthClient extends _AuthClient {
  OauthClient(Client client, String token) : super(client, 'token $token');
}

abstract class _AuthClient extends BaseClient {
  final Client _client;
  final String _authorization;

  _AuthClient(this._client, this._authorization);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers['Authorization'] = _authorization;
    return _client.send(request);
  }
}
