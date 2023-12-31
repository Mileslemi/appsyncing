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

  static String noteConstraintIndex = "UC_note";
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
      'trackingId': trackingId,
      'masterId': masterId,
      'title': title,
      'description': description,
      'user': user,
      'branchName': branchName,
      'posted': posted?.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
      'synced': (synced ?? false) ? 1 : 0,
      'mergeConflict': (mergeConflict ?? false) ? 1 : 0,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['_id'] != null ? map['_id'] as int : null,
      trackingId:
          map['trackingId'] != null ? map['trackingId'] as String : null,
      masterId: map['masterId'] != null ? map['masterId'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      user: map['user'] != null ? map['user'] as String : null,
      branchName:
          map['branchName'] != null ? map['branchName'] as String : null,
      posted: map['posted'] != null
          ? DateTime.parse((map['posted'] ?? '') as String)
          : null,
      lastModified: map['lastModified'] != null
          ? DateTime.parse((map['lastModified'] ?? '') as String)
          : null,
      synced: map['synced'] == 1,
      mergeConflict: map['mergeConflict'] == 1,
    );
  }

  factory NoteModel.fromOnlineMap(Map<String, dynamic> map) {
    // {
//         "id": 3,
//         "posted": "2023-09-08T08:54:40Z",
//         "title": "Note To Test",
//         "description": "This Note was for purpose of testing getting all modified or new Notes since last sync. Modifying Test 2.",
//         "trackingId": "MAINNOTE3",
//         "lastModified": "2023-09-08T09:09:18.535124Z",
//         "user": "",
//         "branchName": "MAIN"
//     },
    return NoteModel(
      trackingId:
          map['trackingId'] != null ? map['trackingId'] as String : null,
      masterId: map['id'] != null ? map['id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      user: map['user'] != null ? map['user'] as String : null,
      branchName:
          map['branchName'] != null ? map['branchName'] as String : null,
      posted: map['posted'] != null
          ? DateTime.parse((map['posted'] ?? '') as String)
          : null,
      lastModified: map['lastModifiedAt'] != null
          ? DateTime.parse((map['lastModifiedAt'] ?? '') as String)
          : null,
      // these two values are not in the json body, set sync as true since we're pulling
      // for mergeConflict, check if that trackingId exists in local, if true check if modified[you can assert this by checking if synced is true, because on modifying synced is automaticall set to false]
      // if synced is false[meaning it has been modified], add title and desc of this online note to conflict table,
      // otherwise set mergeConflict to false
      // synced: map['synced'] == 1,
      // mergeConflict: map['mergeConflict'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  String toOnlineJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory NoteModel.fromOnlineJson(String source) =>
      NoteModel.fromOnlineMap(json.decode(source) as Map<String, dynamic>);

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

  @override
  String toString() {
    return 'NoteModel(id: $id, trackingId: $trackingId, masterId: $masterId, title: $title, description: $description, user: $user, branchName: $branchName, posted: $posted, lastModified: $lastModified, synced: $synced, mergeConflict: $mergeConflict)';
  }
}
