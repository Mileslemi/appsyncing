import 'package:appsyncing/db/appsync_db.dart';
import 'package:appsyncing/models/branch_model.dart';
import 'package:sqflite/sqflite.dart';

class BranchTable {
  BranchTable._();

  // CRUD Functions

  static Future<LocalBranch> create(LocalBranch branch) async {
    // the branch param should have branchName and createdAt DateTime.
    final db = await AppSyncDatabase.instance.database;

    final id = await db.insert(branchTable, branch.toMap());

    return branch.copyWith(id: id);
  }

  static Future<List<LocalBranch>> read() async {
    // since we're storing only one row in this table, we'll get that row
    // this one row we'll set at login page
    final db = await AppSyncDatabase.instance.database;

    List branches = await db.query(branchTable);
    // make sure this list has one branch, although we're fetching all rows,
    // if more than one row, error, contact support, don't log in
    return branches.map((e) => LocalBranch.fromMap(e)).toList();
    // if no row we create first.
  }

  static Future<int> delete(int id) async {
    final db = await AppSyncDatabase.instance.database;

    return await db.delete(
      branchTable,
      where: "${BranchFields.id} = ?",
      whereArgs: [id],
    );
  }

  static Future<int> branchCount() async {
    final db = await AppSyncDatabase.instance.database;

    var count = await db.rawQuery('SELECT COUNT(*) FROM $branchTable');
    //  returns [{COUNT(*): 0}]

    return Sqflite.firstIntValue(count) ?? 2;
  }
}
