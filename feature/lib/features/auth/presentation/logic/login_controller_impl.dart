import 'package:feature/core/core_language.dart';
import 'package:feature/core/core_ui.dart';
import 'package:feature/features/_core/auth_preserver_controller.dart';
import 'package:feature/features/_core/global_mediator.dart';
import 'package:feature/features/auth/domain/domain.dart';
import 'package:feature/features/auth/presentation/logic/login_controller.dart';


class LoginControllerImpl implements LoginController {
  late final tag = runtimeType.toString();
  final AuthRepository repository;
  LoginControllerImpl(this.repository);

  @override
  Future<bool> login(String username, String password) async {
    Logger.on(tag, "login:called");
    try {
    final token = await repository.loginOrThrow(username,password);
      Logger.off(tag, "login:$token");
      await AuthPreserverController.saveToken(
        accessToken: token.first,
        refreshToken: token.second,
      );
      return true;
    } catch (e) {
      AppMediator.onError(e);
      Logger.on(tag, "loginError:$e");
      return false;
    } finally {}
  }

  @override
  LoginUiError? validate(String username, String password) {
    var error = LoginUiError();
    error = error.setUserIdError(username.isEmpty ? 'Username cannot be empty' : null);
    error = error.setPasswordError(password.isEmpty ? 'Password cannot be empty' : null);
    return error.hasError() ? error : null;
  }



}
