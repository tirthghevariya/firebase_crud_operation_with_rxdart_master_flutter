import 'package:firebadecrudoperation/firebase.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  const EditScreen(
      {Key? key, required this.name, required this.city, required this.docs})
      : super(key: key);

  final String name;
  final String docs;
  final String city;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: widget.name);

    TextEditingController cityController =
        TextEditingController(text: widget.city);

    /// Update user business logic
    void updateUser() {
      UserManagement userManagement = UserManagementProvider.of(context);
      userManagement
          .updateUser(
              {'name': nameController.text, 'city': cityController.text},
              widget.docs)
          .then(
            (value) => Navigator.pop(context),
          )
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('SuccessFully Edited'))));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edite Screen'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                onTap: () => nameController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: nameController.value.text.length),
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              // SizeUtils.h2h,
              TextFormField(
                onTap: () => cityController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: cityController.value.text.length),
                controller: cityController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              // SizeUtils.h2h,
              ElevatedButton(
                onPressed: updateUser,
                // onPressed: () {
                //   FocusScope.of(context).unfocus();
                //   collectionReference
                //       .doc(widget.docsc)
                //       .update({
                //         'name': nameController.text,
                //         'city': cityController.text,
                //       })
                //       .then(
                //         (value) => Navigator.pop(context),
                //       )
                //       .then((value) => ScaffoldMessenger.of(context)
                //           .showSnackBar(const SnackBar(
                //               backgroundColor: Colors.green,
                //               content: Text('SuccessFully Edited'))));
                // },
                child: const Text('create'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
