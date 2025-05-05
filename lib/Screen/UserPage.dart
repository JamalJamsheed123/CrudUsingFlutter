import 'package:flutter/material.dart';
import '../Database/DB_helper.dart';
import '../Model/User.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _dbHelper = DBHelper();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _refreshUserList();
  }

  _refreshUserList() async {
    final users = await _dbHelper.getUsers();
    setState(() {
      _users = users;
    });
  }

  _addUser() async {
    final user =
        User(name: _nameController.text, age: int.parse(_ageController.text));
    await _dbHelper.insertUser(user);
    _nameController.clear();
    _ageController.clear();
    _refreshUserList();
  }

  _updateUser(User user) async {
    user.name = _nameController.text;
    user.age = int.parse(_ageController.text);
    await _dbHelper.updateUser(user);
    _refreshUserList();
  }

  _deleteUser(int id) async {
    await _dbHelper.deleteUser(id);
    _refreshUserList();
  }

  _showForm(User? user) {
    if (user != null) {
      _nameController.text = user.name;
      _ageController.text = user.age.toString();
    }

    showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name')),
                  TextField(
                      controller: _ageController,
                      decoration: InputDecoration(labelText: 'Age')),
                  ElevatedButton(
                      onPressed: () {
                        if (user == null) {
                          _addUser();
                        } else {
                          _updateUser(user);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(user == null ? 'Add' : 'Update'))
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite CRUD")),
      body: Column(
        children: [
          // Header row
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey.shade300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("ID", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Age", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Actions", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (_, index) {
                final user = _users[index];
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${user.id}"),
                      Text("${user.name}"),
                      Text("${user.age}"),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showForm(user),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user.id!),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
