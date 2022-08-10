import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_utils/mysql_utils.dart';

var db = MysqlUtils(
  settings: {
    'host': dotenv.get('HOST_IP'),
    'port': int.parse(dotenv.get('HOST_PORT')),
    'user': dotenv.get('HOST_USER'),
    'password': dotenv.get('HOST_PASS'),
    'db': dotenv.get('HOST_DB_NAME'),
    'maxConnections': 10,
    'secure': false,
    'prefix': '',
    'pool': false,
    'collation': 'utf8mb4_0900_ai_ci',
  },
  errorLog: (error) => error,
  sqlLog: (sql) => sql,
  connectInit: (db1) => 'COMPLETE',
);

Future saveToMysql(
  String username,
  String userpass,
  String userfullname,
) async {
  var isAlive = await db.isConnectionAlive();
  if (!isAlive) return;

  try {
    await db.query(
        'INSERT INTO tbl_crud_test (user_name, user_pass, user_fullname) VALUES(:user_name, :user_pass, :user_fullname)',
        values: {
          'user_name': username,
          'user_pass': userpass,
          'user_fullname': userfullname,
        },
        debug: false);
  } catch (e) {
    return e;
  }

  return 'SAVED';
}

Future selectAllMysql() async {
  var isAlive = await db.isConnectionAlive();
  if (!isAlive) return;

  var listRes = [];

  var getUser = await db.query('SELECT * FROM tbl_crud_test', debug: false);

  for (var item in getUser.rowsAssoc) {
    // print(item.assoc());
    listRes.add(item.assoc());
  }

  return listRes;
}

Future deleteUserMysql(int uid) async {
  var isAlive = await db.isConnectionAlive();
  if (!isAlive) return;

  await db.query('DELETE FROM tbl_crud_test WHERE id=:uid',
      values: {
        'uid': uid,
      },
      debug: false);

  return 'DELETED';
}

Future updateMysql(
  int uid,
  String username,
  String userpass,
  String userfullname,
) async {
  var isAlive = await db.isConnectionAlive();
  if (!isAlive) return;

  await db.query(
      'UPDATE tbl_crud_test SET user_name=:user_name, user_pass=:user_pass, user_fullname=:user_fullname WHERE id=:uid',
      values: {
        'uid': uid,
        'user_name': username,
        'user_pass': userpass,
        'user_fullname': userfullname,
      },
      debug: false);

  // await db.update(
  //   table: 'tbl_crud_test',
  //   updateData: {
  //     'user_name': username,
  //     'user_pass': userpass,
  //     'user_fullname': userfullname,
  //   },
  //   where: {'id': uid},
  // );

  return 'UPDATED';
}
