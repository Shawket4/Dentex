import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

StateMachineController getRiveController(Artboard artboard, String state) {
  StateMachineController? controller =
      StateMachineController.fromArtboard(artboard, state);
  artboard.addController(controller!);
  return controller;
}

class RiveAsset {
  final String file, artboard, stateMachineName, smi, title;
  final Widget route;
  late SMIBool? input;
  RiveAsset({
    required this.file,
    required this.artboard,
    required this.stateMachineName,
    required this.smi,
    required this.title,
    required this.route,
    this.input,
  });
  set setInput(SMIBool status) {
    input = status;
  }
}
