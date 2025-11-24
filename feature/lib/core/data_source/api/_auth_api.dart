part of '../data_source.dart';
abstract interface class AuthApi{
  Future<Pair<String,String>> loginOrThrow(String username, String password);
  Future<User> userOrThrow();
  Future<Pair<String,String>> readAccessTokenOrThrow(String refreshToken);
}

class User {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String? image;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.image,
  });
  @override
  String toString() {
    return 'User(id: $id, username: $username, firstName: $firstName, lastName: $lastName, image: $image)';
  }
}
