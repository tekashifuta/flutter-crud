import 'package:crud_test/services.dart';
import 'package:crud_test/worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

final control = Get.find<MysqlController>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      initialBinding: MysqlBindings(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _unameConn = TextEditingController();
  final _fnameConn = TextEditingController();
  final _upassConn = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _unameConn.dispose();
    _fnameConn.dispose();
    _fnameConn.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD TEST'),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _unameConn,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Username'),
                  hintText: 'Input Username'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _fnameConn,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Fullname'),
                  hintText: 'Input Fullname'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _upassConn,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Password'),
                  hintText: 'Input Password'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () async {
                    await saveToMysql(
                      _unameConn.text.trim(),
                      _fnameConn.text.trim(),
                      _upassConn.text.trim(),
                    );

                    control.isUpdate.value = true;
                    _unameConn.clear();
                    _fnameConn.clear();
                    _upassConn.clear();
                  },
                  child: const Text('SAVE'),
                ),
              ),
            ],
          ),
          Obx(() {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: control.userList.length,
              itemBuilder: (BuildContext context, int index) {
                final users = control.userList[index];

                return ListTile(
                  title: Text(users['user_name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () async {
                          await _editDialog(context, users);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _deleteDialog(
                            users['user_name'],
                            int.parse(users['id']),
                          );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 0,
                  color: Colors.red,
                );
              },
            );
          }),
        ],
      )),
    );
  }
}

Future _deleteDialog(String delUser, int delUserID) {
  return Get.defaultDialog(
      title: 'Delete User',
      content: Text('Do you want to delete $delUser?'),
      actions: [
        TextButton(
          onPressed: () async {
            await control.deleteUser(delUserID);
            control.isUpdate.value = true;
            Get.back();
          },
          child: const Text('Delete'),
        )
      ]);
}

Future _editDialog(
  BuildContext context,
  dynamic users,
) {
  final unameConn = TextEditingController(text: users['user_name']);
  final fullnameConn = TextEditingController(text: users['user_fullname']);
  final upassConn = TextEditingController(text: users['user_pass']);

  return Get.defaultDialog(
    title: 'Update Mysql',
    content: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: unameConn,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Password'),
                hintText: 'Input Password'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: fullnameConn,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Password'),
                hintText: 'Input Password'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: upassConn,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Password'),
                hintText: 'Input Password'),
          ),
        ),
      ],
    ), //gi statefull nko kay dili ko ka setstate
    actions: [
      TextButton(
        onPressed: () async {
          await control.updateUser(
            int.parse(users['id']),
            unameConn.text.trim(),
            upassConn.text.trim(),
            fullnameConn.text.trim(),
          );
          control.isUpdate.value = true;
          Get.back();
        },
        child: const Text('Update'),
      )
    ],
  );
}
