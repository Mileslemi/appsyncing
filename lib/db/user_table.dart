import 'package:appsyncing/db/appsync_db.dart';
import 'package:appsyncing/models/user_model.dart';

class UserTable {
  UserTable._();

  static Future<BranchUser> create({required BranchUser user}) async {
    final db = await AppSyncDatabase.instance.database;

    int id = await db.insert(usertable, user.toMap());

    return user.copyWith(id: id);
  }

  static Future<BranchUser> authLocalUser(
      {required String username, required String password}) async {
    final db = await AppSyncDatabase.instance.database;

    BranchUser user = BranchUser();

    List users = await db.query(
      usertable,
      where:
          "${BranchUserFields.username} = ? and ${BranchUserFields.password} = ?",
      whereArgs: [username, password],
    );
    List mappedUsers = users.map((e) => BranchUser.fromMap(e)).toList();

    // what if list is empty
    if (mappedUsers.isNotEmpty) {
      //since user is unique, return first item
      user = mappedUsers[0];
    }
    return user;
  }

  static Future<int> delete(int id) async {
    final db = await AppSyncDatabase.instance.database;

    return await db.delete(
      usertable,
      where: "${BranchUserFields.id} = ?",
      whereArgs: [id],
    );
  }
}
