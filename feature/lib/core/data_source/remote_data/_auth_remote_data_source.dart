part of '../data_source.dart';
//Inspired by Template Method Design pattern
abstract class AuthRDSTemplate implements AuthApi {
  late final tag = runtimeType.toString();

  String get loginUrl => URLFactory.urls.login;

  String get readUserUrl => URLFactory.urls.user;

  dynamic createLoginPayload(String username, String password);

  dynamic createRefreshTokenPayload(String refreshToken);

  User parseUserOrThrow(String response);

  Pair<String, String> parseTokensOrThrow(String response);

  final client = NetworkClient.createBaseClient();

  //@formatter:off
  @override
  Future<Pair<String, String>> loginOrThrow(String username, String password) async {
    final payload = createLoginPayload(username, password);
    final response = await client.postOrThrow(url: loginUrl, payload: payload);
    Logger.off(tag, "response=$response");
    return parseTokensOrThrow(response);
  }
  //@formatter:off
  @override
  Future<User> userOrThrow() async {
    late final client = NetworkClient.createClientDecorator();
    final response = await client.getOrThrow(url: readUserUrl);
    return parseUserOrThrow(response);
  }
  //@formatter:off
  @override
  Future<Pair<String,String>> readAccessTokenOrThrow(String refreshToken) async{
    final response= await client.postOrThrow(
        url: URLFactory.urls.refreshToken,
        payload: createRefreshTokenPayload(refreshToken)
    );
    return parseTokensOrThrow(response);
}
}


class   AuthRemoteDataSource extends AuthRDSTemplate {
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
  User parseUserOrThrow(String response) {
    throwFailureOrSkip(response, tag);
    final json = jsonDecode(response) as Json;
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
Pair<String, String> parseTokensOrThrow(String response) {
    throwFailureOrSkip(response, tag);
    final json = jsonDecode(response) as Json;
    final access=json['accessToken'];
    final refresh=json['refreshToken'];
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