import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

const String branchTable = "branch";

class BranchFields {
  static List<String> branchRetrieveFields = [branchName];

  static String id = "_id";
  static String branchName = "branchName";
  static String createdAt = "createdAt";
}

class LocalBranch {
  int? id;
  String? branchName;
  DateTime? createdAt;

  LocalBranch({
    this.id,
    this.branchName,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'branchName': branchName,
      'createdAt': createdAt?.toIso8601String()
    };
  }

  factory LocalBranch.fromMap(Map<String, dynamic> map) {
    return LocalBranch(
      id: map['_id'] != null ? map['_id'] as int : null,
      branchName:
          map['branchName'] != null ? map['branchName'] as String : null,
      createdAt: DateTime.parse((map['createdAt'] ?? '') as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalBranch.fromJson(String source) =>
      LocalBranch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Branch(id: $id, branchName: $branchName, createdAt: $createdAt)';

  LocalBranch copyWith({
    int? id,
    String? branchName,
    DateTime? createdAt,
  }) {
    return LocalBranch(
      id: id ?? this.id,
      branchName: branchName ?? this.branchName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// for fetching branches online for first setup, the dropdown option when logging in.
class FetchedOnlineBranch {
  int? id;
  String? branchName;
  bool? assigned;
  FetchedOnlineBranch({
    this.id,
    this.branchName,
    this.assigned,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'branchname': branchName,
      'assigned': assigned,
    };
  }

  factory FetchedOnlineBranch.fromMap(Map<String, dynamic> map) {
    return FetchedOnlineBranch(
      id: map['id'] != null ? map['id'] as int : null,
      branchName:
          map['branchname'] != null ? map['branchname'] as String : null,
      assigned: map['assigned'] != null ? map['assigned'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FetchedOnlineBranch.fromJson(String source) =>
      FetchedOnlineBranch.fromMap(json.decode(source) as Map<String, dynamic>);
}
