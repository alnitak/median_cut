
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';

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
                    Pointer<Uint8> palette)>>('getPalette')
        .asFunction<
            Pointer<Void> Function(
                int numColors,
                Pointer<Uint8> imgBuffer,
                int imgBufferLength,
                Pointer<Uint8> palette)>();
  }

  List<Color> medianCut(int numColors, Uint8List imgBuffer) {
    List<Color> ret = [];
    Pointer<Uint8> buffer = uint8ListToPointer(imgBuffer);
    Pointer<Uint8> palette = calloc<Uint8>(numColors * 4);

    _getPaletteFfi(numColors, buffer, imgBuffer.length, palette);

    Uint8List l = palette.asTypedList(numColors * 4);

    for (int i=0; i<numColors*4; i+=4) {
      ret.add(Color.fromARGB(
          palette.elementAt(i+3).value,
          palette.elementAt(i+2).value,
          palette.elementAt(i+1).value,
          palette.elementAt(i+0).value
      ));
    }

    calloc.free(buffer);
    calloc.free(palette);
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
