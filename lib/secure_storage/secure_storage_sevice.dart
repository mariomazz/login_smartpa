import 'entitys/login_tokens_service.dart';

class SecureStorageService {
  final LoginTokenService _loginTokensService = LoginTokenService();
  LoginTokenService get loginTokensService => _loginTokensService;
}
