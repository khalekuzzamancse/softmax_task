part of 'domain.dart';
abstract interface class AuthRepository{
  Future<Pair<String,String>> loginOrThrow(String username, String password);
  Future<UserModel> userOrThrow();
}
class UserModel {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String? image;

  UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.image,
  });
  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, firstName: $firstName, lastName: $lastName, image: $image)';
  }
}