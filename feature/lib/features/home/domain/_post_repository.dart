part of 'domain.dart';
abstract interface class PostRepository{
  Future<PaginationWrapper<List<PostModel>>> readOrThrow(String? nextUrl);
  Future<PostModel> detailsOrThrow(String id);
  Future<PaginationWrapper<List<PostModel>>> searchOrThrow(String query);

}

class PostModel {
  final String id;
  final String title;
  final String body;
  final List<String> tags;
  final int views;
  final int userId;
  final int likes;
  final int dislikes;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.views,
    required this.userId,
    required this.likes,
    required this.dislikes,
  });


}

