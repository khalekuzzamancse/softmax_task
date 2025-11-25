import 'package:feature/features/auth/domain/domain.dart';
import 'package:feature/features/home/domain/domain.dart';

//@formatter:off
abstract interface class HomeController {
  Stream<List<PostModel>> get posts;
  Future<UserModel?> readUser();
  Future<void> readPost();
  Future<void> search(String query);
  Future<void> readNext();
}
