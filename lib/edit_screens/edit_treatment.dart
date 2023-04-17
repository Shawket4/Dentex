// ignore_for_file: use_build_context_synchronously
import 'package:dentex/components/dialog.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/main.dart';
import 'package:dentex/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTreatmentScreen extends StatefulWidget {
  const EditTreatmentScreen({super.key, required this.treatment});
  final Condition treatment;
  @override
  State<EditTreatmentScreen> createState() => _EditTreatmentScreenState();
}

class _EditTreatmentScreenState extends State<EditTreatmentScreen> {
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
    if (widget.treatment.name != null) {
      name.text = widget.treatment.name!;
    }
    if (widget.treatment.price != null) {
      price.text = widget.treatment.price.toString();
    } else {
      price.text = "0.0";
    }
    if (widget.treatment.color != null) {
      selectedColor = widget.treatment.color!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController hexColor = TextEditingController();
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF011627),
        title: const Text(
          "Edit Treatment",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Save",
                        style: GoogleFonts.jost(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.save_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  showLoadingDialog(context);
                  try {
                    var response = await postData(
                            "$ServerIP/api/protected/EditTreatment",
                            {
                              "ID": widget.treatment.id,
                              "name": name.text,
                              "price": double.parse(price.text),
                              "hex_color": HexColor(selectedColor).toHex(),
                            },
                            context)
                        .timeout(const Duration(seconds: 5));

                    if (response["message"] == "Updated Successfully") {
                      showSuccessDialog(context);
                    }
                  } catch (e) {
                    showErrorDialog(context);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
