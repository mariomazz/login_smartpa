/* import 'package:flutter_appauth/flutter_appauth.dart';

class AuthenticationConfigurations {
  final String tenantId;

  final String clientId;
  final String redirectUrl = 'it.asf.portici:/oauthredirect';
  final String issuer;

  final List<String> scopes;

  final String discoveryUrl;

  final String postLogoutRedirectUrl;

  final String authorizationEndpoint;
  final String tokenEndpoint;
  final String endSessionEndpoint;
  final String authorityId;

  late AuthorizationServiceConfiguration serviceConfiguration;

  late Map<String, String> parameter;

  final List<String> promptValues = ['login'];

  AuthenticationConfigurations({
    required this.tenantId,
    required this.clientId,
    required this.issuer,
    required this.scopes,
    required this.discoveryUrl,
    required this.postLogoutRedirectUrl,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    required this.endSessionEndpoint,
    required this.authorityId,
  }) {
    serviceConfiguration = AuthorizationServiceConfiguration(
      authorizationEndpoint: authorizationEndpoint,
      tokenEndpoint: tokenEndpoint,
      endSessionEndpoint: endSessionEndpoint,
    );
    parameter ==
        {
          'authorityId': authorityId,
        };
  }
}
 */