import 'dart:convert';

const String usertable = "branchUser";

class BranchUserFields {
  static List<String> branchUsersRetrievables = [username, password, email];

  static String id = "_id";
  static String username = "username";
  static String password = "password";
  static String firstName = "firstName";
  static String lastName = "lastName";
  static String email = "email";
  static String isAdmin = "isAdmin";
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BranchUser {
  int? id;
  String? username;
  String? password;
  String? firstName;
  String? lastName;
  String? email;
  bool? isAdmin;
  BranchUser({
    this.id,
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.email,
    this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'isAdmin': isAdmin,
    };
  }

  factory BranchUser.fromMap(Map<String, dynamic> map) {
    return BranchUser(
      username: map['username'] != null ? map['username'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      isAdmin: map['isAdmin'] != null ? map['isAdmin'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BranchUser.fromJson(String source) =>
      BranchUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BranchUser(id: $id, username: $username, password: $password, firstName: $firstName, lastName: $lastName, email: $email, isAdmin: $isAdmin)';
  }
}
