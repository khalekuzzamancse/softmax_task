import 'dart:ui';

import 'package:feature/core/core_language.dart';
import 'package:feature/core/core_network.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'auth_preserver_controller.dart';

/// Must initialize it in the app, Global mediator for whole app
class AppMediator implements AuthExpireObserver, TokenManager {
  static final AppMediator instance = AppMediator._();
  static final _messageToUi = BehaviorSubject<String?>.seeded(null);
  static Stream<String?> messageToUI = _messageToUi.stream;
  static  VoidCallback? _onSessionExpire;
  static void setOnSessionExpire(VoidCallback onSessionExpire) {
    _onSessionExpire = onSessionExpire;
  }


  static void onError(Object e) {
    if(e is UnauthorizedException){
      instance.onSessionExpire();
      return;
    }
    String msg = "Something went wrong";
    if (e is CustomException) {
      msg = e.message;
    } else if (e is ClientException) {
      msg = 'Unable to connect. Check your internet or address.';
    }
    showSnackBar(msg);
  }

  static void showSnackBar(String message) async {
    var msg = toSnackBarMessage(message);
    if (alreadyShowing(msg)) return;
    _messageToUi.add(msg);
    await delayInMs(3000);
    _messageToUi.add(null);
  }

  static String toSnackBarMessage(String message) {
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
    _onSessionExpire?.call();
  }

  @override
  Future<String> getTokenOrThrow() => AuthPreserverController.readAccessTokenOrThrow();

  @override
  Future<void> updateAccessToken() => AuthPreserverController.refreshAccessToken();
}
