part of '../data_source.dart';

abstract class PostRDSTemplate implements PostApi {
  String get url => URLFactory.urls.postRead;

  String searchUrl(String query) => URLFactory.urls.searchPost(query);
  late final tag = runtimeType.toString();

  String detailsUrl(String id) => URLFactory.urls.postDetails(id);
  late final client = NetworkClient.createClientDecorator();
  PaginationWrapper<List<Post>> parseOrThrow(String response);
  Post parsePostOrThrow(dynamic response);

  @override
  Future<PaginationWrapper<List<Post>>> readOrThrow(String? nextUrl) async {
    Logger.off(tag, "readOrThrow:$nextUrl");
    final response = await client.getOrThrow(url: nextUrl ?? url);
    Logger.off(tag, "readOrThrow:$response");
    return parseOrThrow(response);
  }

  @override
  Future<Post> detailsOrThrow(String id) async {
    final response = await client.getOrThrow(url: detailsUrl(id));
    return parsePostOrThrow(jsonDecode(response));
  }

  @override
  Future<PaginationWrapper<List<Post>>> searchOrThrow(String query) async {
    final response = await client.getOrThrow(url: searchUrl(query));
    Logger.off(tag, "readOrThrow:$response");
    return parseOrThrow(response);
  }
}

class PostRemoteDataSource extends PostRDSTemplate {
  PostRemoteDataSource._();

  static PostApi create() => PostRemoteDataSource._();

  @override
  PaginationWrapper<List<Post>> parseOrThrow(String response) {
    throwFailureOrSkip(response, tag);
    final decoded = jsonDecode(response);
    final json = decoded as Map<String, dynamic>;
    final total = json['total'] as int;
    final skip = json['skip'] as int;
    final limit = json['limit'] as int;
    final posts = (json['posts'] as List<dynamic>).map((e) {
      final post = e as Map<String, dynamic>;
      return parsePostOrThrow(post);
    });
    final nextSkip = skip + limit;
    final String? nextUrl = nextSkip <= total
        ? "https://dummyjson.com/posts?limit=$limit&skip=$nextSkip"
        : null;
    return PaginationWrapper(data: posts.toList(), nextUrl: nextUrl);
  }

  @override
  Post parsePostOrThrow(response) {
    if(response is String) throwFailureOrSkip(response, tag);
    else if(response is Map) throwFailureOrSkip(jsonEncode(response), tag);
    final post = response;
    final tags = (post['tags'] as List<dynamic>)
        .map((tag) => tag as String)
        .toList();
    return Post(
      id: "${post['id']}",
      title: post['title'],
      body: post['body'],
      tags: tags,
      views: post['views'],
      userId: post['userId'],
      reactions: Reactions(
        likes: post['reactions']['likes'],
        dislikes: post['reactions']['dislikes'],
      ),
    );
  }

}
