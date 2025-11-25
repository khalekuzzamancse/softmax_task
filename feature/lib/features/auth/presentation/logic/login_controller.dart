///
abstract interface class LoginController{
  Future<bool> login(String username, String password);
  LoginUiError? validate(String username, String password);
}
abstract interface class LoginUiState{}
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