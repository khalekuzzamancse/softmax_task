part of '../data_source.dart';

abstract class PostRDSTemplate implements PostApi {
  String get url => URLFactory.urls.postRead;

  String detailsUrl(String id) => URLFactory.urls.postDetails(id);
  late final client = NetworkClient.createClientDecorator();

  PaginationWrapper<List<Post>> parseOrThrow(dynamic response);

  Post parsePostOrThrow(dynamic response);

  @override
  Future<PaginationWrapper<List<Post>>> readOrThrow() async {
    final response = await client.getOrThrow(url: url);
    return parseOrThrow(jsonDecode(response));
  }

  @override
  Future<Post> detailsOrThrow(String id) async {
    final response = await client.getOrThrow(url: detailsUrl(id));
    return parsePostOrThrow(jsonDecode(response));
  }
}

class PostRemoteDataSource extends PostRDSTemplate {
  PostRemoteDataSource._();

  static PostApi create() => PostRemoteDataSource._();

  @override
  PaginationWrapper<List<Post>> parseOrThrow(response) {
    final json = response as Map<String, dynamic>;
    final total = json['total'] as int;
    final skip = json['skip'] as int;
    final limit = json['limit'] as int;
    final posts = (json['posts'] as List<dynamic>).map((e) {
      final post = e as Map<String, dynamic>;
      return parsePostOrThrow(post);
    });
    return PaginationWrapper(data: posts.toList(), count: total);
  }

  @override
  Post parsePostOrThrow(response) {
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
