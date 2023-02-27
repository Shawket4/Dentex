import 'package:clinic_management/screens/login_page.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

List<String> _permissionList = const ["Student", "Teacher"];
String selectedPermission = _permissionList[0];

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController permissionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0b132b),
        title: const Text(
          "New Account",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Quick Quiz',
                  style: TextStyle(
                      // color: Color(0xFF0b132b),
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6.0),
                child: const Text(
                  'Create a New Account',
                  style: TextStyle(fontSize: 18),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autocorrect: false,
                controller: nameController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF0b132b),
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Color(0xFF0b132b),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autocorrect: false,
                controller: usernameController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF0b132b),
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: Color(0xFF0b132b),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autocorrect: false,
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF0b132b),
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Color(0xFF0b132b),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownSearch<String>(
                dropdownSearchTextAlign: TextAlign.left,
                searchFieldProps: const TextFieldProps(
                  autocorrect: false,
                  cursorColor: Color(0xFF0b132b),
                ),
                popupItemBuilder: (context, item, isSelected) =>
                    SizedBox(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      color: isSelected ? const Color(0xFF5bc0be) :const Color(0xFF0b132b),
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                dropdownSearchDecoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF0b132b),
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  labelText: "Permission*",
                  labelStyle: TextStyle(
                    color: Color(0xFF0b132b),
                  ),
                ),
                mode: Mode.MENU,
                showSelectedItems: true,
                showSearchBox: false,
                enabled: true,
                items: _permissionList,
                selectedItem: selectedPermission,
                onChanged: (item) => setState(() {
                  selectedPermission = item!;
                }),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(10),
            //   child: TextField(
            //     autocorrect: false,
            //     controller: permissionController,
            //     decoration: const InputDecoration(
            //       focusedBorder: OutlineInputBorder(
            //         borderSide: BorderSide(
            //           color: Color(0xFF0b132b),
            //           width: 2.0,
            //         ),
            //       ),
            //       border: OutlineInputBorder(),
            //       labelText: 'Permission',
            //       labelStyle: TextStyle(
            //         color: Color(0xFF0b132b),
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0b132b)),
                child: const Text(
                  "Sign up",
                ),
                onPressed: () async {
                  if (selectedPermission == _permissionList[0]) {
                   permissionController.text = "0";
                  } else if (selectedPermission == _permissionList[1]) {
                    permissionController.text = "1";
                  }
                  var response = await dio.post("$ServerIP/RegisterUser/", data: {
                    "name": nameController.text,
                    "email": usernameController.text,
                    "password": passwordController.text,
                    "permission": permissionController.text,
                  });
                  var message = response.data["Message"];
                  print(message);
                  if (message == "User Created Successfully") {
                    Navigator.of(context)
                        .pop(MaterialPageRoute(builder: (BuildContext context) {
                      return const LoginPage();
                    }));
                  } else if (message == "An Error Has Occurred") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          title: const Text("An Error has occured"),
                          content: const Text("Please fill all fields"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                'Ok',
                                style: TextStyle(
                                  color: Color(0xFF5bc0be),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("have an account?"),
                TextButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Color(0xFF5bc0be)),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(MaterialPageRoute(builder: (BuildContext context) {
                      return const LoginPage();
                    }));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}