part of '../data_source.dart';

abstract interface class URLFactory {
  ///Instead of "create" used names as "urls" so that can call as
  /// URLFactory.urls.activeLoansRead, for better readability
  static  URLFactory urls = URLFactoryRemoteServer._();
  String get login;
  String get user;
  String get postRead;
  String  postDetails(String id);

  get refreshToken => null;
}
class URLFactoryRemoteServer implements URLFactory {
  ///To force pure abstraction and single source of instance creation
  URLFactoryRemoteServer._();
  final base="https://dummyjson.com";
  @override
  String get login => '$base/auth/login';
  @override
  String get user => '$base/auth/me';
  @override
  String get postRead => "$base/posts?limit=20&skip=0";
  @override
  String postDetails(String id)=>"$base/posts/$id";

  @override
  get refreshToken => throw UnimplementedError();


}

class URLFactoryLocalServer implements URLFactory {
  ///To force pure abstraction and single source of instance creation
  URLFactoryLocalServer._();

  @override
  // TODO: implement login
  String get login => throw UnimplementedError();

  @override
  // TODO: implement postRead
  String get postRead => throw UnimplementedError();

  @override
  // TODO: implement user
  String get user => throw UnimplementedError();

  @override
  // TODO: implement refreshToken
  get refreshToken => throw UnimplementedError();

  @override
  String postDetails(String id) {

    // TODO: implement postDetails
    throw UnimplementedError();
  }


}

