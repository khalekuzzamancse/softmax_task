import 'package:feature/core/core_language.dart';
import 'package:feature/core/core_network.dart';
import 'auth_preserver_controller.dart';

/// Must initialize it in the app, Global mediator for whole app
class AppMediator implements AuthExpireObserver, TokenManager {
  static final AppMediator instance = AppMediator._();

  ///await to make sure dependency...
  Future<void> init() async {
    NetworkClientDecorator.registerAsListener(this);
    NetworkClientDecorator.setTokenManager(this);
    Logger.clearLogs();
  }

  AppMediator._();

  late final tag = runtimeType.toString();

  @override
  void onSessionExpire() {
    Logger.on(tag, 'onSessionExpire');
    //  Get.offAndToNamed(AppRouteService.login);
  }

  @override
  Future<String> getTokenOrThrow() => AuthPreserverController.retrieveTokenOrThrow();

  @override
  Future<void> updateAccessToken() => AuthPreserverController.refreshAccessToken();
}
