import 'package:rive/rive.dart';

StateMachineController getRiveController(Artboard artboard, String state) {
  StateMachineController? controller =
      StateMachineController.fromArtboard(artboard, state);
  artboard.addController(controller!);
  return controller;
}
