import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// we can populate this table with conflicts, and provide a UI that user can compare and merge and sync.
//if conflict is true in Note table, before modifying anew, user should be restricted to first resolving
//the conflict, and sync, and then can modify again.
const String noteConflictTable = "noteConflict";

class NoteConflictFields {
  static List<String> noteConflictRetrievables = [id, trackingId, title, desc];

  static String id = "_id";
  static String trackingId = "trackingId";
  static String title = "title";
  static String desc = "description";
}

// we first pull data, and then if there's a conflict ....
class NoteConflict {
  int? id;
  String? trackingId;
  String? title;
  String? description;
  NoteConflict({
    this.id,
    this.trackingId,
    this.title,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'trackingId': trackingId,
      'title': title,
      'description': description,
    };
  }

  factory NoteConflict.fromMap(Map<String, dynamic> map) {
    return NoteConflict(
      id: map['_id'] != null ? map['_id'] as int : null,
      trackingId:
          map['trackingId'] != null ? map['trackingId'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteConflict.fromJson(String source) =>
      NoteConflict.fromMap(json.decode(source) as Map<String, dynamic>);

  NoteConflict copyWith({
    int? id,
    String? trackingId,
    String? title,
    String? description,
  }) {
    return NoteConflict(
      id: id ?? this.id,
      trackingId: trackingId ?? this.trackingId,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
