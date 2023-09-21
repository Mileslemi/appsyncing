import 'dart:convert';

String syncTableName = "sync";

class SyncFields {
  static String id = "_id";
  static String tableName = "tableName";
  static String lastSync = "lastSync";
  static String rowsEntered = "rowsEntered";

  static String syncconstraintIndex = "UC_sync";
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SyncModel {
  int? id;
  String? tableName;
  DateTime? lastSync;
  int? rowsEntered;
  SyncModel({
    this.id,
    this.tableName,
    this.lastSync,
    this.rowsEntered,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'tableName': tableName,
      'lastSync': lastSync?.toIso8601String(),
      'rowsEntered': rowsEntered,
    };
  }

  factory SyncModel.fromMap(Map<String, dynamic> map) {
    return SyncModel(
      id: map['_id'] != null ? map['_id'] as int : null,
      tableName: map['tableName'] != null ? map['tableName'] as String : null,
      lastSync: map['lastSync'] != null
          ? DateTime.parse((map['lastSync'] ?? '') as String)
          : null,
      rowsEntered:
          map['rowsEntered'] != null ? map['rowsEntered'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SyncModel.fromJson(String source) =>
      SyncModel.fromMap(json.decode(source) as Map<String, dynamic>);

  SyncModel copyWith({
    int? id,
    String? tableName,
    DateTime? lastSync,
    int? rowsEntered,
  }) {
    return SyncModel(
      id: id ?? this.id,
      tableName: tableName ?? this.tableName,
      lastSync: lastSync ?? this.lastSync,
      rowsEntered: rowsEntered ?? this.rowsEntered,
    );
  }
}
