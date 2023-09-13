// ignore_for_file: public_member_api_docs, sort_constructors_first
class NoteModel {
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
}
