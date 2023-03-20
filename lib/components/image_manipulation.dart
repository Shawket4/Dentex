import 'package:flutter/services.dart';
import 'package:image/image.dart' as ui;

Future<Uint8List> returnColoredTooth(String imagePath, Color color) async {
  late Uint8List imageBytes;
  var data = await rootBundle.load(imagePath);
  imageBytes = data.buffer.asUint8List();
  final image = ui.decodeImage(imageBytes);
  final pixels = image!.getBytes(order: ui.ChannelOrder.rgba);
  final int length = pixels.lengthInBytes;
  for (var i = 0; i < length; i += 4) {
    ///           PIXELS
    /// =============================
    /// | i | i + 1 | i + 2 | i + 3 |
    /// =============================
    // pixels[i] represents Red
    // pixels[i + 1] represents Green
    // pixels[i + 2] represents Blue
    // pixels[i + 3] represents Alpha

    // Detect the light blue color & switch it with the desired color's RGB value.
    if (pixels[i] == 18 && pixels[i + 1] == 42 && pixels[i + 2] == 222) {
      pixels[i] = color.red;
      pixels[i + 1] = color.green;
      pixels[i + 2] = color.blue;
    }
  }
  return ui.encodePng(image);
}
