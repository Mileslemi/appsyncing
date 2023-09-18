import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

const String branchTable = "branch";

class BranchFields {
  static List<String> branchRetrieveFields = [branchName];

  static String id = "_id";
  static String branchName = "branchName";
  static String createdAt = "createdAt";
}

class Branch {
  int? id;
  String? branchName;
  DateTime? createdAt;

  Branch({
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

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      id: map['_id'] != null ? map['_id'] as int : null,
      branchName:
          map['branchName'] != null ? map['branchName'] as String : null,
      createdAt: DateTime.parse((map['createdAt'] ?? '') as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Branch.fromJson(String source) =>
      Branch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Branch(id: $id, branchName: $branchName, createdAt: $createdAt)';

  Branch copyWith({
    int? id,
    String? branchName,
    DateTime? createdAt,
  }) {
    return Branch(
      id: id ?? this.id,
      branchName: branchName ?? this.branchName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// for fetching branches online for first setup, the dropdown option when logging in.
class MasterBranches {
  String? branchName;
  bool? assigned;
  MasterBranches({
    this.branchName,
    this.assigned,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'branchName': branchName,
      'assigned': assigned,
    };
  }

  factory MasterBranches.fromMap(Map<String, dynamic> map) {
    return MasterBranches(
      branchName:
          map['branchName'] != null ? map['branchName'] as String : null,
      assigned: map['assigned'] != null ? map['assigned'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MasterBranches.fromJson(String source) =>
      MasterBranches.fromMap(json.decode(source) as Map<String, dynamic>);
}
