part of 'data.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl._();

  static PostRepository create() => PostRepositoryImpl._();

  @override
  Future<PostModel> detailsOrThrow(String id) async {
    final postApi = ApiFactory.create().post();
    final entity = await postApi.detailsOrThrow(id);
    return mapToPostModel(entity);
  }

  @override
  Future<PaginationWrapper<List<PostModel>>> readOrThrow(
    String? nextUrl,
  ) async {
    final postApi = ApiFactory.create().post();
    final wrapper = await postApi.readOrThrow(nextUrl);
    final entities = wrapper.data.map((e) => mapToPostModel(e)).toList();
    return PaginationWrapper(data: entities, nextUrl: wrapper.nextUrl);
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

  @override
  Future<PaginationWrapper<List<PostModel>>> searchOrThrow(String query) async {
    final postApi = ApiFactory.create().post();
    final wrapper = await postApi.searchOrThrow(query);
    final entities = wrapper.data.map((e) => mapToPostModel(e)).toList();
    return PaginationWrapper(data: entities, nextUrl: wrapper.nextUrl);
  }
}
