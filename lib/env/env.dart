import 'package:envied/envied.dart';

part 'env.g.dart';

//Luego de cambiar el archivo .env, correr el siguiente comando:
//dart pub add envied dev:envied_generator dev:build_runner
//dart run build_runner build

@Envied(path: 'lib/env/.env')
abstract class Env {
  @EnviedField(varName: 'DEBUG_MODE')
  static const bool debugMode = _Env.debugMode;

  @EnviedField(varName: 'API_KEY')
  static const String apiKey = _Env.apiKey;

  @EnviedField(varName: 'PACKAGE_NAME')
  static const String packageName = _Env.packageName;

  @EnviedField(varName: 'ID_CLIENT')
  static const String idClient = _Env.idClient;

  @EnviedField(varName: 'PROJECT_ID')
  static const String projectId = _Env.projectId;

  @EnviedField(varName: 'AUTH_URI')
  static const String authUri = _Env.authUri;

  @EnviedField(varName: 'TOKEN_URI')
  static const String tokenUri = _Env.tokenUri;

  @EnviedField(varName: 'AUTH_PROVIDER_X509_CERT_URL')
  static const String authProviderX509CertUrl = _Env.authProviderX509CertUrl;
}
