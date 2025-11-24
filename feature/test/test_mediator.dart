
import 'package:feature/core/core_language.dart';
import 'package:feature/core/core_network.dart';
import 'package:feature/core/data_source/data_source.dart';


/// Must initialize it in the app, Global mediator for whole app
class TestMediator implements AuthExpireObserver, TokenManager {
  static final TestMediator instance = TestMediator._();
  static var _accessToken="";
  static var _refreshToken="";
  TestMediator._();
  static void setTokens(String accessToken, String refreshToken){
    _accessToken=accessToken;
    _refreshToken=refreshToken;
  }
  ///await to make sure dependency...
  Future<void> init() async {
    NetworkClientDecorator.registerAsListener(this);
    NetworkClientDecorator.setTokenManager(this);
  }

  late final tag = runtimeType.toString();

  @override
  void onSessionExpire() {
    Logger.on(tag, 'onSessionExpire');
    //  Get.offAndToNamed(AppRouteService.login);
  }

  @override
  Future<String> getTokenOrThrow()async{
    return  _accessToken;
  }

  @override
  Future<void> updateAccessToken()async{
    final token = await ApiFactory.create().auth().readAccessTokenOrThrow(_refreshToken);
    _accessToken=token.first;
    _refreshToken=token.second;
  }
}
