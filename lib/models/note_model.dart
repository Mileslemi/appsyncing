import 'dart:convert';

const String noteTableName = "note";

class NoteFields {
  static final List<String> fetchValues = [
    trackingId,
    masterId,
    title,
    desc,
    user,
    branchName,
    posted,
    lastModified,
    synced,
    mergeConflict
  ];
  static String id = "_id";
  static String trackingId = "trackingId";
  static String masterId = "masterId";
  static String title = "title";
  static String desc = "description ";
  static String user = "user";
  static String branchName = "branchName ";
  static String posted = "posted";
  static String lastModified = "lastModified";
  static String synced = "synced";
  static String mergeConflict = "mergeConflict";
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NoteModel {
  int? id;
  String?
      trackingId; //A combination of BranchName/server + TableName + Auto_int
  //we'll get the autoInt: when creating a note object in db an id will be returned, use that.
  int? masterId;
  String? title;
  String? description;
  String? user;
  String? branchName;
  DateTime? posted;
  DateTime? lastModified;
  bool? synced;
  bool? mergeConflict;
  NoteModel({
    this.id,
    this.trackingId,
    this.masterId,
    this.title,
    this.description,
    this.user,
    this.branchName,
    this.posted,
    this.lastModified,
    this.synced,
    this.mergeConflict,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'tracking_id': trackingId,
      'master_id': masterId,
      'title': title,
      'description': description,
      'user': user,
      'branch_name': branchName,
      'posted': posted?.toIso8601String(),
      'last_modified': lastModified?.toIso8601String(),
      'synced': (synced ?? false) ? 1 : 0,
      'merge_conflict': (mergeConflict ?? false) ? 1 : 0,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      trackingId:
          map['tracking_id'] != null ? map['tracking_id'] as String : null,
      masterId: map['master_id'] != null ? map['master_id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      user: map['user'] != null ? map['user'] as String : null,
      branchName:
          map['branch_name'] != null ? map['branch_name'] as String : null,
      posted: map['posted'] != null
          ? DateTime.parse((map['posted'] ?? '') as String)
          : null,
      lastModified: map['last_modified'] != null
          ? DateTime.parse((map['last_modified'] ?? '') as String)
          : null,
      synced: map['synced'] == 1,
      mergeConflict: map['merge_conflict'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  NoteModel copyWith({
    int? id,
    String? trackingId,
    int? masterId,
    String? title,
    String? description,
    String? user,
    String? branchName,
    DateTime? posted,
    DateTime? lastModified,
    bool? synced,
    bool? mergeConflict,
  }) {
    return NoteModel(
      id: id ?? this.id,
      trackingId: trackingId ?? this.trackingId,
      masterId: masterId ?? this.masterId,
      title: title ?? this.title,
      description: description ?? this.description,
      user: user ?? this.user,
      branchName: branchName ?? this.branchName,
      posted: posted ?? this.posted,
      lastModified: lastModified ?? this.lastModified,
      synced: synced ?? this.synced,
      mergeConflict: mergeConflict ?? this.mergeConflict,
    );
  }
}
