import 'package:flutter/material.dart';
import 'package:login_smartpa/secure_storage/secure_storage_configurations.dart';
import 'package:login_smartpa/secure_storage/secure_storage_sevice.dart';
import 'autentication_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  //static final AuthenticationProvider autentication = AuthenticationProvider();
  late AuthenticationService porticiAuthService;
  final SecureStorageService _secureStorage = SecureStorageService();

  AuthenticationProvider({required this.porticiAuthService});

  bool _isLogged = true;
  bool get getIsLogged => _isLogged;

  set setAuth(bool isLogged) {
    _isLogged = isLogged;
    notifyListeners();
  }

  String? _accessToken;

  Future<String?> get getAccessToken async {
    if (_accessToken == null) {
      _accessToken = await _secureStorage.loginTokensService
          .getTokenByKey(SecureStorageKeys.DATABASE_KEY_ACCESSTOKEN);
      return _accessToken;
    }
    return _accessToken;
  }

  set setAccessToken(String? accessToken) => _accessToken = accessToken;

  Future<void> authenticationStatusChange() async =>
      _isLogged ? await logout() : await login();

  Future<void> login() async {
    final loginResponse = await porticiAuthService.login();
    if (loginResponse.item1) {
      setAccessToken = loginResponse.item2;
      _isLogged = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final bool isNotLogged = await porticiAuthService.logout();
    if (isNotLogged) {
      setAccessToken = null;

      _isLogged = false;
      notifyListeners();
    }
  }

  Future<bool> refreshToken() async {
    final refreshResponse = await porticiAuthService.refreshToken();
    if (refreshResponse.item2 != null) {
      setAccessToken = refreshResponse.item2;
    }

    return refreshResponse.item1;
  }
}
