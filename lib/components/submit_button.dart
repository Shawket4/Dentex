// ignore_for_file: use_build_context_synchronously

import 'package:dentex/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void submitButtonOnPressed(BuildContext context, BuildContext dialogContext,
    String url, dynamic data, Widget route) async {
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
    var response =
        await postData(url, data).timeout(const Duration(seconds: 5));

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
                            builder: (_) => route,
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
  // return Container(
  //   height: 50,
  //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
  //   child: ElevatedButton(
  //       style:
  //           ElevatedButton.styleFrom(backgroundColor: const Color(0xFF011627)),
  //       child: const Text(
  //         "Add",
  //         style: TextStyle(
  //           fontSize: 24,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       onPressed: () async {
  //         showDialog(
  //             context: context,
  //             barrierDismissible: false,
  //             builder: (context) {
  //               dialogContext = context;
  //               return Dialog(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12.0),
  //                 ),
  //                 child: SizedBox(
  //                   height: 400,
  //                   width: double.infinity,
  //                   child: Center(
  //                     // Display lottie animation
  //                     child: Lottie.asset(
  //                       "assets/lottie/Loading.json",
  //                       height: 200,
  //                       width: 200,
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             });
  //         try {
  //           var response =
  //               await postData(url, data).timeout(const Duration(seconds: 5));

  //           if (response["message"] == "Registered Successfully") {
  //             // ignore: use_build_context_synchronously
  //             showDialog(
  //                 context: context,
  //                 barrierDismissible: false,
  //                 builder: (context) {
  //                   dialogContext = context;
  //                   return Dialog(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12.0),
  //                     ),
  //                     child: SizedBox(
  //                       height: 400,
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           SizedBox(
  //                             width: double.infinity,
  //                             child: Center(
  //                               // Display lottie animation
  //                               child: Lottie.asset(
  //                                 "assets/lottie/Success.json",
  //                                 height: 300,
  //                                 width: 300,
  //                               ),
  //                             ),
  //                           ),
  //                           TextButton(
  //                             onPressed: () {
  //                               Navigator.pop(dialogContext);
  //                               Navigator.pushReplacement(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (_) => route,
  //                                 ),
  //                               );
  //                             },
  //                             child: const Text(
  //                               "Close",
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 20,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 });
  //           } else {
  //             showDialog(
  //                 context: context,
  //                 barrierDismissible: false,
  //                 builder: (context) {
  //                   dialogContext = context;
  //                   return Dialog(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12.0),
  //                     ),
  //                     child: SizedBox(
  //                       height: 400,
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           SizedBox(
  //                             width: double.infinity,
  //                             child: Center(
  //                               // Display lottie animation
  //                               child: Lottie.asset(
  //                                 "assets/lottie/Error.json",
  //                                 height: 300,
  //                                 width: 300,
  //                               ),
  //                             ),
  //                           ),
  //                           TextButton(
  //                             onPressed: () {
  //                               Navigator.pop(dialogContext);
  //                               Navigator.pop(dialogContext);
  //                             },
  //                             child: const Text(
  //                               "Close",
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 20,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 });
  //           }
  //         } catch (e) {
  //           showDialog(
  //               context: context,
  //               barrierDismissible: false,
  //               builder: (context) {
  //                 dialogContext = context;
  //                 return Dialog(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12.0),
  //                   ),
  //                   child: SizedBox(
  //                     height: 400,
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         SizedBox(
  //                           width: double.infinity,
  //                           child: Center(
  //                             // Display lottie animation
  //                             child: Lottie.asset(
  //                               "assets/lottie/Error.json",
  //                               height: 300,
  //                               width: 300,
  //                             ),
  //                           ),
  //                         ),
  //                         TextButton(
  //                           onPressed: () {
  //                             Navigator.pop(dialogContext);
  //                             Navigator.pop(dialogContext);
  //                           },
  //                           child: const Text(
  //                             "Close",
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 20,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               });
  //         }
  //       }),
  // );
}
