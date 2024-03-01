// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_crud_php/user_model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameCtrl = TextEditingController();
  final _familyCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  String serverMsg = '';
  final List<User> _usersList = [];

  // use 10.0.2.2 instead of localhost for working on Android Emulator!!!
  // use localhost or 127.0.0.1 for working on Web Browsers!!!
  final String staticIp = "http://10.0.2.2";

  void _postRequest() async {
    try {
      final response = await http.post(Uri.parse("$staticIp/api/?myApi=insert"),
          body: {
            'name': _nameCtrl.text,
            'family': _familyCtrl.text,
            'age': _ageCtrl.text
          }.convertToJson());

      _nameCtrl.text = '';
      _familyCtrl.text = '';
      _ageCtrl.text = '';

      if (response.statusCode == 200)
      // ignore: curly_braces_in_flow_control_structures
      {
        serverMsg = "Data Successfully inserted";
        _getRequest();
      } else
        // ignore: curly_braces_in_flow_control_structures
        serverMsg = "Something went wrong!!!";
    } catch (error) {
      print(error.toString());
    }
  }

  void _getRequest() async {
    try {
      final response =
          await http.get(Uri.parse("$staticIp/api/?myApi=get"));

      if (response.statusCode == 200)
      // ignore: curly_braces_in_flow_control_structures
      {
        serverMsg = "Data Get Successfully";
        _usersList.clear();
        for (final jsonItem in jsonDecode(response.body)) {
          _usersList.add(User.fromJson(jsonItem));
        }
        setState(() {});
      } else
        // ignore: curly_braces_in_flow_control_structures
        serverMsg = "Something went wrong!!!";
      setState(() {});
    } catch (error) {
      serverMsg = error.toString();
      setState(() {});
    }
  }

  void _deleteRequest(int id) async {
    try {
      final response = await http.delete(
          Uri.parse("$staticIp/api/?myApi=delete"),
          body: {'id': id}.convertToJson());

      if (response.statusCode == 200)
      // ignore: curly_braces_in_flow_control_structures
      {
        serverMsg = "Data Deleted Successfully";
        _getRequest();
      } else
        // ignore: curly_braces_in_flow_control_structures
        serverMsg = "Delete Failed !!!";
      setState(() {});
    } catch (error) {
      serverMsg = error.toString();
      setState(() {});
    }
  }

  void _updateRequest(int id, User user) async {
    try {
      final response = await http.post(
          Uri.parse("$staticIp/api/?myApi=update"),
          body: {
            'id': id,
            'name': user.name,
            'family': user.family,
            'age': user.age
          }.convertToJson());

      if (response.statusCode == 200)
      // ignore: curly_braces_in_flow_control_structures
      {
        print(response.body);
        serverMsg = "Data Updated Successfully";
        _getRequest();
      } else
        // ignore: curly_braces_in_flow_control_structures
        serverMsg = "Update Failed !!!";
      setState(() {});
    } catch (error) {
      serverMsg = error.toString();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(hintText: 'Name'),
                      controller: _nameCtrl,
                    ),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Family'),
                      controller: _familyCtrl,
                    ),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Age'),
                      controller: _ageCtrl,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      serverMsg,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _usersList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey.shade100,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_usersList[index].name} ${_usersList[index].family} ${_usersList[index].age}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  highlightColor: Colors.green.withOpacity(0.4),
                                  onPressed: () {
                                    _updateRequest(
                                        _usersList[index].id,
                                        User(
                                            id: _usersList[index].id,
                                            name: _nameCtrl.text,
                                            family: _familyCtrl.text,
                                            age: int.parse(_ageCtrl.text.isEmpty
                                                ? '0'
                                                : _ageCtrl.text)));
                                  },
                                  icon: const Icon(Icons.edit,
                                      color: Colors.green),
                                ),
                                IconButton(
                                  highlightColor: Colors.red.withOpacity(0.4),
                                  onPressed: () {
                                    _deleteRequest(_usersList[index].id);
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    })),
            const SizedBox(
              height: 90,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _postRequest();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension on Map {
  String convertToJson() => jsonEncode(this);
}
