import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

// Ref. http://palette-maker.herokuapp.com/index.html

/// Palette class
class Palette {
  Color color;
  double luminance;
  double percentage;

  Palette(this.color, this.luminance, this.percentage);
}

/// isolate callback
Future<List<Palette>> _isolateCallBack(Map<int, dynamic> args) {
  DynamicLibrary nativeLib = Platform.isAndroid
      ? DynamicLibrary.open("libmedian_cut.so")
      : DynamicLibrary.process();

  // C decl   void getPalette(int32_t numColors, int8_t *imgBuffer, int64_t imgBufferLength, int8_t *palette)
  var getPaletteFfi = nativeLib
      .lookup<
          NativeFunction<
              Pointer<Void> Function(
                  Int32 numColors,
                  Pointer<Uint8> imgBuffer,
                  Int64 imgBufferLength,
                  Pointer<Uint8> palette,
                  Pointer<Double> percentages)>>('getPalette')
      .asFunction<
          Pointer<Void> Function(
              int numColors,
              Pointer<Uint8> imgBuffer,
              int imgBufferLength,
              Pointer<Uint8> palette,
              Pointer<Double> percentages)>();

  int numColors = args[0];
  Uint8List imgBuffer = args[1];
  Completer<List<Palette>> completer = Completer<List<Palette>>();
  List<Palette> ret = [];
  Pointer<Uint8> buffer = calloc<Uint8>(imgBuffer.length);
  Pointer<Uint8> palette = calloc<Uint8>(numColors * 4);
  Pointer<Double> percentages = calloc<Double>(numColors * 8);

  for (var i = 0; i < imgBuffer.length; i++) {
    buffer.elementAt(i).value = imgBuffer[i];
  }

  getPaletteFfi(numColors, buffer, imgBuffer.length, palette, percentages);

  for (int i = 0; i < numColors; i++) {
    Color c = Color.fromARGB(
        palette.elementAt(i * 4 + 3).value,
        palette.elementAt(i * 4 + 2).value,
        palette.elementAt(i * 4 + 1).value,
        palette.elementAt(i * 4).value);
    ret.add(Palette(c, c.computeLuminance(), percentages.elementAt(i).value));
  }

  calloc.free(buffer);
  calloc.free(palette);
  calloc.free(percentages);

  completer.complete(ret);

  return completer.future;
}

class MedianCut {
  /// Compute image median-cut palette
  ///
  /// [numcolors]: number of colors to be computed
  /// [imgBuffer]: raw image pixels data. Colors sequence must be in rgba format
  ///
  static Future<List<Palette>> medianCut(
          int numColors, Uint8List imgBuffer) async =>
      compute(_isolateCallBack, {0: numColors, 1: imgBuffer});
}
