part of '../data_source.dart';
//Inspired by Template Method Design pattern
abstract class AuthRDSTemplate implements AuthApi {
  late final tag = runtimeType.toString();

  String get loginUrl => URLFactory.urls.login;

  String get readUserUrl => URLFactory.urls.user;

  dynamic createLoginPayload(String username, String password);

  dynamic createRefreshTokenPayload(String refreshToken);

  User parseUserOrThrow(dynamic response);

  Pair<String, String> parseTokensOrThrow(dynamic response);

  final client = NetworkClient.createBaseClient();

  //@formatter:off
  @override
  Future<Pair<String, String>> loginOrThrow(String username, String password) async {
    final payload = createLoginPayload(username, password);
    final response = await client.postOrThrow(url: loginUrl, payload: payload);
    Logger.off(tag, "response=$response");
    return parseTokensOrThrow(jsonDecode(response));
  }
  //@formatter:off
  @override
  Future<User> userOrThrow() async {
    late final client = NetworkClient.createClientDecorator();
    final response = await client.getOrThrow(url: readUserUrl);
    return parseUserOrThrow(jsonDecode(response));
  }
  //@formatter:off
  @override
  Future<Pair<String,String>> readAccessTokenOrThrow(String refreshToken) async{
    final response= await client.postOrThrow(
        url: URLFactory.urls.refreshToken,
        payload: createRefreshTokenPayload(refreshToken)
    );
    return parseTokensOrThrow(jsonDecode(response));
}
}


class AuthRemoteDataSource extends AuthRDSTemplate {
  //Forcing abstraction
  AuthRemoteDataSource._();
  static AuthApi create() => AuthRemoteDataSource._();

  @override
  createLoginPayload(String username, String password) {
    return {
      "username": username,
      "password": password,
      "credentials": "include"
    };
  }

  @override
  User parseUserOrThrow(response) {
    final json = response as Map<String, dynamic>;
    final user = User(
        id: "${json['id']}",
        username: json['username'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        image: json['image'],
    );
    return user;
  }


@override
Pair<String, String> parseTokensOrThrow(response) {
    final access=response['accessToken'];
    final refresh=response['refreshToken'];
   return Pair(access,refresh);

}

  @override
  createRefreshTokenPayload(String refreshToken) {
    return {
      "refreshToken": refreshToken,
      "credentials": "include"
    };
  }


}