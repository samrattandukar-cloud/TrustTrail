import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  final source = img.decodeImage(
    File('assets/images/trusttrail_full_logo.png').readAsBytesSync(),
  )!;
  var mark = img.copyCrop(source, x: 240, y: 175, width: 620, height: 500);
  mark = mark.convert(numChannels: 4);
  for (final pixel in mark) {
    if (pixel.r > 242 && pixel.g > 242 && pixel.b > 242) {
      pixel.a = 0;
    }
  }

  final icon = img.Image(width: 1024, height: 1024, numChannels: 4);
  img.fill(icon, color: img.ColorRgba8(244, 247, 250, 255));
  final resized = img.copyResize(mark, width: 820, height: 660);
  img.compositeImage(icon, resized, dstX: 102, dstY: 182);
  File('assets/images/app_icon.png').writeAsBytesSync(img.encodePng(icon));

  // The splash keeps the mark on a white rounded card (as in the design),
  // which preserves the logo's white interior details on dark backgrounds.
  final card = img.Image(width: 512, height: 512, numChannels: 4);
  for (final pixel in card) {
    pixel.setRgba(0, 0, 0, 0);
  }
  const radius = 92;
  for (var y = 0; y < 512; y++) {
    for (var x = 0; x < 512; x++) {
      if (_insideRoundedRect(x, y, 512, 512, radius)) {
        card.setPixelRgba(x, y, 255, 255, 255, 255);
      }
    }
  }
  final splashMark = img.copyResize(mark, width: 416, height: 336);
  img.compositeImage(card, splashMark, dstX: 48, dstY: 88);
  File('assets/images/trusttrail_mark.png').writeAsBytesSync(img.encodePng(card));

  stdout.writeln('Created app_icon.png and trusttrail_mark.png');
}

bool _insideRoundedRect(int x, int y, int w, int h, int radius) {
  final nx = x.clamp(radius, w - radius - 1);
  final ny = y.clamp(radius, h - radius - 1);
  final dx = x - nx;
  final dy = y - ny;
  return dx * dx + dy * dy <= radius * radius;
}
