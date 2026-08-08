import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Draws [watermarkText] diagonally across the center of [imageBytes] and
/// returns the re-encoded JPEG bytes. Pure on-device processing — no network
/// calls, no platform channels.
///
/// [angle]   - rotation in degrees. Negative tilts the text from
///             bottom-left to top-right (typical stock-photo watermark look).
/// [opacity] - 0-255. Lower = more subtle/see-through.
/// [jpegQuality] - 1-100 quality of the re-encoded jpeg.
Future<Uint8List> addDiagonalTextWatermark(
  Uint8List imageBytes,
  String watermarkText, {
  double angle = -30,
  int opacity = 110,
  int jpegQuality = 90,
}) async {
  img.Image? source = img.decodeImage(imageBytes);
  if (source == null) {
    // Not a decodable image — return untouched rather than throwing,
    // so a bad file never blocks the upload flow.
    return imageBytes;
  }

  // Normalise camera/crop EXIF rotation so the watermark is drawn upright.
  source = img.bakeOrientation(source);

  // Scale font size relative to the photo so it reads well on both small
  // avatars and larger crops.
  final img.BitmapFont font = source.width >= 700
      ? img.arial48
      : source.width >= 350
          ? img.arial24
          : img.arial14;

  // Repeat the text so the diagonal band reads across the whole photo
  // instead of one small label lost in the center.
  final String line = "   $watermarkText   $watermarkText   ";

  // Measure the rendered width the same way drawString does internally,
  // so the transparent canvas we draw on is neither clipped nor oversized.
  int textWidth = 0;
  for (final c in line.codeUnits) {
    final ch = font.characters[c];
    textWidth += ch?.xAdvance ?? (font.base ~/ 2);
  }
  textWidth += 40; // padding so rotation doesn't clip characters
  final int textHeight = font.lineHeight + 20;

  // Transparent RGBA canvas to draw the text on before rotating it.
  final img.Image textLayer = img.Image(
    width: textWidth,
    height: textHeight,
    numChannels: 4,
  );

  img.drawString(
    textLayer,
    line,
    font: font,
    color: img.ColorRgba8(255, 255, 255, opacity),
  );

  final img.Image rotatedText = img.copyRotate(
    textLayer,
    angle: angle,
    interpolation: img.Interpolation.cubic,
  );

  img.compositeImage(
    source,
    rotatedText,
    center: true,
    blend: img.BlendMode.alpha,
  );

  return img.encodeJpg(source, quality: jpegQuality);
}
