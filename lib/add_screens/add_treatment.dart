// ignore_for_file: use_build_context_synchronously
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lottie/lottie.dart';

class AddTreatmentScreen extends StatefulWidget {
  const AddTreatmentScreen({super.key});

  @override
  State<AddTreatmentScreen> createState() => _AddTreatmentScreenState();
}

class _AddTreatmentScreenState extends State<AddTreatmentScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();

  Color selectedColor = Colors.black;
  List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];
  @override
  void initState() {
    price.text = "0.0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController hexColor = TextEditingController();
    BuildContext dialogContext = context;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF011627),
        title: const Text(
          "Add Treatment",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              autocorrect: false,
              controller: name,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF011627),
                    width: 2.0,
                  ),
                ),
                border: OutlineInputBorder(),
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: Color(0xFF011627),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              autocorrect: false,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: price,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF011627),
                    width: 2.0,
                  ),
                ),
                border: OutlineInputBorder(),
                labelText: 'Price',
                labelStyle: TextStyle(
                  color: Color(0xFF011627),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 70,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Pick Condition Color",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ColorPicker(
                                    pickerColor: selectedColor,
                                    // ignore: deprecated_member_use
                                    showLabel: false,
                                    enableAlpha: false,
                                    onColorChanged: (color) {
                                      setState(() {
                                        selectedColor = color;
                                      });
                                    }),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: const Text(
                                      "Close",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              child: BlockPicker(
                                                  pickerColor: selectedColor,
                                                  availableColors: colors,
                                                  onColorChanged: (color) {
                                                    setState(() {
                                                      selectedColor = color;
                                                      Navigator.pop(context);
                                                    });
                                                  }),
                                            );
                                          });
                                    },
                                    child: const Text(
                                      "Presets",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  icon: Icon(
                    Icons.brush,
                    color: selectedColor,
                  ),
                )
              ],
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(10),
          //   child: TextField(
          //     autocorrect: false,
          //     keyboardType:
          //         const TextInputType.numberWithOptions(decimal: true),
          //     controller: hexColor,
          //     decoration: const InputDecoration(
          //       focusedBorder: OutlineInputBorder(
          //         borderSide: BorderSide(
          //           color: Color(0xFF011627),
          //           width: 2.0,
          //         ),
          //       ),
          //       border: OutlineInputBorder(),
          //       labelText: 'Hex Color',
          //       labelStyle: TextStyle(
          //         color: Color(0xFF011627),
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF011627)),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        dialogContext = context;
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: SizedBox(
                            height: 400,
                            width: double.infinity,
                            child: Center(
                              // Display lottie animation
                              child: Lottie.asset(
                                "assets/lottie/Loading.json",
                                height: 200,
                                width: 200,
                              ),
                            ),
                          ),
                        );
                      });
                  try {
                    var response = await postData(
                        "$ServerIP/api/protected/RegisterTreatment", {
                      "treatment_name": name.text,
                      "treatment_price": double.parse(price.text),
                      "hex_color": HexColor(selectedColor).toHex(),
                    }).timeout(const Duration(seconds: 5));

                    if (response["message"] == "Registered Successfully") {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            dialogContext = context;
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: SizedBox(
                                height: 400,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                        // Display lottie animation
                                        child: Lottie.asset(
                                          "assets/lottie/Success.json",
                                          height: 300,
                                          width: 300,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const HomeScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            dialogContext = context;
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: SizedBox(
                                height: 400,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                        // Display lottie animation
                                        child: Lottie.asset(
                                          "assets/lottie/Error.json",
                                          height: 300,
                                          width: 300,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        Navigator.pop(dialogContext);
                                      },
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  } catch (e) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          dialogContext = context;
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: SizedBox(
                              height: 400,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Center(
                                      // Display lottie animation
                                      child: Lottie.asset(
                                        "assets/lottie/Error.json",
                                        height: 300,
                                        width: 300,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text(
                                      "Close",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }
}
