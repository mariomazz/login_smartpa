import 'dart:developer';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:login_smartpa/secure_storage/secure_storage_configurations.dart';
import 'package:login_smartpa/secure_storage/secure_storage_sevice.dart';
import 'package:tuple/tuple.dart';
import 'authentication_configurations.dart';

class AuthenticationService {
  AuthenticationService({required this.loginPorticiConfiguration});
  final SecureStorageService _secureStorageService = SecureStorageService();
  late AuthenticationConfigurations loginPorticiConfiguration;

  final FlutterAppAuth _appAuth = FlutterAppAuth();

  Future<Tuple2<bool, String?>> login() async {
    try {
      final AuthorizationTokenResponse? requestLogin =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          loginPorticiConfiguration.clientId,
          loginPorticiConfiguration.redirectUrl,
          scopes: loginPorticiConfiguration.scopes,
          issuer: loginPorticiConfiguration.issuer,
          preferEphemeralSession: false,
          promptValues: loginPorticiConfiguration.promptValues,
          serviceConfiguration: loginPorticiConfiguration.serviceConfiguration,
          additionalParameters: loginPorticiConfiguration.parameter,
        ),
      );

      if (requestLogin != null &&
          requestLogin.accessToken != null &&
          requestLogin.refreshToken != null &&
          requestLogin.accessTokenExpirationDateTime != null &&
          requestLogin.idToken != null) {
        await _secureStorageService.loginTokensService.saveTokensIntoDB(
          accessToken: requestLogin.accessToken!,
          refreshToken: requestLogin.refreshToken!,
          expiryDate: requestLogin.accessTokenExpirationDateTime!.toString(),
          idToken: requestLogin.idToken!,
        );
      } else {
        throw Exception(
            'Alcuni parametri non sono arrivati dalla richiesta di LOGIN');
      }
      return Tuple2(true, requestLogin.accessToken);
    } catch (e) {
      log('ERRORE LOGIN - PORTICI AUTENTICATION SERVICE - $e');
      return const Tuple2(false, null);
    }
  }

  Future<Tuple2<bool, String?>> refreshToken() async {
    try {
      final refreshToken = await _secureStorageService.loginTokensService
          .getTokenByKey(SecureStorageKeys.DATABASE_KEY_REFRESHTOKEN);

      if (refreshToken == null || refreshToken == '') {
        throw Exception(
            'Nessun refresh token trovato nel database - secure storage');
      }

      final TokenResponse? requestRefreshToken = await _appAuth.token(
        TokenRequest(
          loginPorticiConfiguration.clientId,
          loginPorticiConfiguration.redirectUrl,
          discoveryUrl: loginPorticiConfiguration.discoveryUrl,
          refreshToken: refreshToken,
          scopes: loginPorticiConfiguration.scopes,
          additionalParameters: loginPorticiConfiguration.parameter,
        ),
      );

      if (requestRefreshToken != null &&
          requestRefreshToken.accessToken != null &&
          requestRefreshToken.refreshToken != null &&
          requestRefreshToken.accessTokenExpirationDateTime != null &&
          requestRefreshToken.idToken != null) {
        await _secureStorageService.loginTokensService.saveTokensIntoDB(
          accessToken: requestRefreshToken.accessToken!,
          refreshToken: requestRefreshToken.refreshToken!,
          expiryDate:
              requestRefreshToken.accessTokenExpirationDateTime!.toString(),
          idToken: requestRefreshToken.idToken!,
        );
      } else {
        throw Exception(
            'Alcuni parametri non sono arrivati dalla richiesta di REFRESH_TOKEN');
      }

      return Tuple2(true, requestRefreshToken.accessToken);
    } catch (e) {
      log('ERRORE REFRESH TOKEN - PORTICI AUTENTICATION SERVICE - $e');
      return const Tuple2(false, null);
    }
  }

  Future<bool> logout() async {
    try {
      await _secureStorageService.loginTokensService.clearALLtokensIntoDB();
      return true;
    } catch (e) {
      log('ERRORE LOGOUT - PORTICI AUTENTICATION SERVICE - $e');
      return false;
    }
  }
}
