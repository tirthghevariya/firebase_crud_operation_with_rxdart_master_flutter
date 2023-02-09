import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebadecrudoperation/firebase.dart';
import 'package:firebadecrudoperation/utils/size_utils.dart';
import 'package:firebadecrudoperation/view/edit_screen.dart';
import 'package:flutter/material.dart';
import '../collection_route/collection_route.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  FocusNode userNameNode = FocusNode();
  FocusNode cityNode = FocusNode();

  void clearText() {
    nameController.clear();
    cityController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    userNameNode.dispose();
    cityNode.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  /// Add user business logic here
  void _addUser() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      UserManagement userManagement = UserManagementProvider.of(context);
      userManagement
          .addUser({'name': nameController.text, 'city': cityController.text})
          .then(
            (value) => clearText(),
          )
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('SuccessFully Added the field'))))
          .catchError(
            (e) => log('AddError $e'),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Crud operation fireBase with rx dart.',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      } else {
                        return null;
                      }
                    },
                    onFieldSubmitted: (submit) {
                      userNameNode.unfocus();
                      FocusScope.of(context).requestFocus(cityNode);
                    },
                    focusNode: userNameNode,
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Enter your name'),
                    ),
                  ),
                  SizeUtils.h2h,
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a city';
                      } else {
                        return null;
                      }
                    },
                    focusNode: cityNode,
                    controller: cityController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Enter your city'),
                    ),
                  ),
                ],
              ),
            ),
            SizeUtils.h2h,
            ElevatedButton(
              onPressed: _addUser,
              child: const Text('submit'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: collectionReference.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<DocumentSnapshot> docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${docs[index].get('name')}'),
                        subtitle: Text('${docs[index].get('city')}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              /// you can delete user from here
                              onPressed: () {
                                UserManagement userManagement =
                                    UserManagementProvider.of(context);
                                userManagement.deleteUser(docs[index].id);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditScreen(
                                        docs: docs[index].id,
                                        city: '${docs[index]['city']}',
                                        name: '${docs[index]['name']}',
                                      ),
                                    ));
                              },
                              icon: const Icon(Icons.edit),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
