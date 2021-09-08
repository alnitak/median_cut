
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';

class Palette {
  Color color;
  double percentage;

  Palette(this.color, this.percentage);
}

class MedianCut {
  late DynamicLibrary _nativeLib;
  var _getPaletteFfi;


  static final MedianCut _instance = MedianCut._privateConstructor();

  factory MedianCut() {
    return _instance;
  }
  MedianCut._privateConstructor() {
    _nativeLib = Platform.isAndroid
        ? DynamicLibrary.open("libmedian_cut.so")
        : DynamicLibrary.process();

    // C decl   void getPalette(int32_t numColors, int8_t *imgBuffer, int64_t imgBufferLength, int8_t *palette)
    _getPaletteFfi = _nativeLib
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
  }

  List<Palette> medianCut(int numColors, Uint8List imgBuffer) {
    List<Palette> ret = [];
    Pointer<Uint8> buffer = uint8ListToPointer(imgBuffer);
    Pointer<Uint8> palette = calloc<Uint8>(numColors * 4);
    Pointer<Double> percentages = calloc<Double>(numColors*8);

    _getPaletteFfi(numColors, buffer, imgBuffer.length, palette, percentages);

    for (int i=0; i<numColors; i++) {
      ret.add(
        Palette(
          Color.fromARGB(
            palette.elementAt(i*4+3).value,
            palette.elementAt(i*4+2).value,
            palette.elementAt(i*4+1).value,
            palette.elementAt(i*4).value
          ),
          percentages.elementAt(i).value
      ));
    }

    calloc.free(buffer);
    calloc.free(palette);
    calloc.free(percentages);
    return ret;
  }

  Pointer<Uint8> uint8ListToPointer(Uint8List list) {
    final Pointer<Uint8> ptr = calloc<Uint8>(list.length);
    for (var i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }
    return ptr;
  }

}
