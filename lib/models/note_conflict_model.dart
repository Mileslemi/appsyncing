// ignore_for_file: public_member_api_docs, sort_constructors_first
// we can populate this table with conflicts, and provide a UI that user can compare and merge and sync.
//if conflict is true in Note table, before modifying anew, user should be restricted to first resolving
//the conflict, and sync, and then can modify again.

// we first pull data, and then if there's a conflict ....
class NoteConflict {
  String? trackingId;
  String? title;
  String? description;
  NoteConflict({
    this.trackingId,
    this.title,
    this.description,
  });
}
