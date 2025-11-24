import 'package:feature/core/core_language.dart';
import 'package:feature/di_and_mediator/auth_preserver_controller.dart';
import 'package:feature/features/auth/domain/domain.dart';
import 'package:feature/features/auth/presentation/login_controller.dart';
import 'package:rxdart/rxdart.dart';

class LoginControllerImpl implements LoginController{
   late  final tag=runtimeType.toString();
  final _error=BehaviorSubject.seeded(LoginUiError());
  final _isLoading=BehaviorSubject.seeded(false);
  final AuthRepository repository;
  LoginControllerImpl(this.repository);
  var _username='';
  var _password='';
  @override
  Stream<bool> get isLoading=>_isLoading.stream;
  @override
  Stream<LoginUiError> get  errors=>_error.stream;

  @override
  Future<bool> login() async{
    try{
     final token= await repository.loginOrThrow(_username, _password);
     Logger.off(tag, "login:$token");
    await AuthPreserverController.saveToken(accessToken: token.first, refreshToken: token.second);
      return true;
    }
    catch(e){
      Logger.off(tag, "loginError:$e");
      return false;
    }
  }

  @override
  void onUserNameChanged(String value) {
    _username=value;
    _error.add(_error.value.setUserIdError(value.isEmpty?'Username cannot be empty':null));
  }
  @override
  void onPasswordChanged(String value) {
    _password=value;
    _error.add(_error.value.setPasswordError(value.isEmpty?'Password cannot be empty':null));
  }
  @override
  void dispose() {
  }

}