part of '../data_source.dart';

/// Details structure are same that is why no api for the details fetch
abstract interface class PostApi{
  Future<PaginationWrapper<List<Post>>> readOrThrow(String? nextUrl);
  Future<Post> detailsOrThrow(String id);
 }


class Post {
  final String id;
  final String title;
  final String body;
  final List<String> tags;
  final Reactions reactions;
  final int views;
  final int userId;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.views,
    required this.userId,
  });

  @override
  String toString() {
    return 'Post(id: $id, title: $title, body: $body, tags: $tags, reactions: $reactions, views: $views, userId: $userId)';
  }
}

class Reactions {
  final int likes;
  final int dislikes;

  Reactions({
    required this.likes,
    required this.dislikes,
  });

  @override
  String toString() {
    return 'Reactions(likes: $likes, dislikes: $dislikes)';
  }
}
