part of 'data_source.dart';
/// The abstract factory
abstract interface class ApiFactory{
  AuthApi auth();
  PostApi post();
  static ApiFactory create(){
    return ApiFactoryRemote.create();
  }
}
class ApiFactoryRemote implements ApiFactory{
  ApiFactoryRemote._();
  static ApiFactory create(){
    return ApiFactoryRemote._();
  }
  @override
  AuthApi auth()=>AuthRemoteDataSource.create();
  @override
  PostApi post()=>PostRemoteDataSource.create();
}

class ApiFactoryLocal implements ApiFactory{
  ApiFactoryLocal._();
  static ApiFactory create()=> ApiFactoryLocal._();

  @override
  AuthApi auth() {
    // TODO: implement auth
    throw UnimplementedError();
  }

  @override
  PostApi post() {
    // TODO: implement post
    throw UnimplementedError();
  }


}
class ApiFactoryMixed implements ApiFactory{
  ApiFactoryMixed._();
  static ApiFactory create()=> ApiFactoryMixed._();

  @override
  AuthApi auth() {
    // TODO: implement auth
    throw UnimplementedError();
  }

  @override
  PostApi post() {
    // TODO: implement post
    throw UnimplementedError();
  }


}