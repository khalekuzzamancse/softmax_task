///
abstract interface class LoginController{
  Stream<LoginUiError> get errors;
  Stream<bool> get isLoading;
  Future<bool> login();
  void onUserNameChanged(String value);
  void onPasswordChanged(String value);
  void dispose();
}
final class LoginUiError{
  final String? userIdError,passwordError;
  LoginUiError({ this.userIdError,this.passwordError});
  bool hasNoError(){
    return userIdError==null&&passwordError==null;
  }
  bool hasError()=>!hasNoError();

  LoginUiError setUserIdError(String? error){
    return LoginUiError(userIdError: error,passwordError:passwordError);
  }
  LoginUiError setPasswordError(String? error){
    return LoginUiError(userIdError: userIdError,passwordError:error);
  }
}