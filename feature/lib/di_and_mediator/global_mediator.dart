import 'package:feature/core/core_language.dart';
import 'package:feature/core/core_network.dart';
import 'package:rxdart/rxdart.dart';
import 'auth_preserver_controller.dart';

/// Must initialize it in the app, Global mediator for whole app
class AppMediator implements AuthExpireObserver, TokenManager {
  static final AppMediator instance = AppMediator._();
  static final _messageToUi = BehaviorSubject<String?>.seeded(null);
  static Stream<String?> messageToUI = _messageToUi.stream;

  static void onError(Object e) {
    var msg = (e is CustomException) ? e.message : "Something went wrong";
    showSnackBar(msg);
  }

  static void showSnackBar(String message) async {
    var msg = toSnackBarMessage(message);
    if (alreadyShowing(msg)) return;
    _messageToUi.add(msg);
    await delayInMs(3000);
    _messageToUi.add(null);
  }
  static String toSnackBarMessage(String message){
    var msg = message;
    if (msg.length >= 80) {
      msg = msg.substring(0, 77) + '...';
    }
    return msg;
  }
  static bool alreadyShowing(message) {
    return _messageToUi.value == message;
  }
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
  Future<String> getTokenOrThrow() =>
      AuthPreserverController.retrieveTokenOrThrow();

  @override
  Future<void> updateAccessToken() =>
      AuthPreserverController.refreshAccessToken();
}
