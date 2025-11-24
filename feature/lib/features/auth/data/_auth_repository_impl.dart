part of 'data.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl._();

  static AuthRepository create() => AuthRepositoryImpl._();

  @override
  Future<Pair<String, String>> loginOrThrow(String username, String password) {
    late final authApi = ApiFactory.create().auth();
    return authApi.loginOrThrow(username, password);
  }

  @override
  Future<UserModel> userOrThrow() async {
    late final authApi = ApiFactory.create().auth();
    final entity = await authApi.userOrThrow();
    return UserModel(
      id: entity.id,
      username: entity.username,
      firstName: entity.firstName,
      lastName: entity.lastName,
      image: entity.image,
    );
  }

  PostModel mapToPostModel(Post entity) {
    return PostModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      tags: entity.tags,
      views: entity.views,
      userId: entity.userId,
      likes: entity.reactions.likes,
      dislikes: entity.reactions.dislikes,
    );
  }
}
