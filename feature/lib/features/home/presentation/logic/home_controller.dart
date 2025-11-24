
import 'package:feature/features/auth/domain/domain.dart';
import 'package:feature/features/home/domain/domain.dart';

abstract interface class HomeController{
  Stream<UserModel?> get user;
  Stream<List<PostModel>> get posts;
  Stream<bool> get isLoading;
  Stream<bool> get isNextLoading;
  void readUser();
  void readPost();
  void search(String query);
  void onPostListEnd();
}