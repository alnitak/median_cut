import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as image;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:median_cut/median_cut.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final stopwatch = Stopwatch();
  Duration elapsed = Duration.zero;
  List<Palette> palette = [];
  int numPaletteColors = 8;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/landscape-scene.jpeg', fit: BoxFit.scaleDown)
                ),

                ElevatedButton(
                  onPressed: () async{
                    stopwatch.start();
                    final ByteData assetImageByteData = await rootBundle.load('assets/landscape-scene.jpeg');
                    image.Image? baseSizeImage = image.decodeImage(assetImageByteData.buffer.asUint8List());
                    Uint8List imgBuffer = baseSizeImage!.getBytes();

                    palette = MedianCut().medianCut(numPaletteColors, imgBuffer);
                    setState(() {
                      elapsed = stopwatch.elapsed;
                      stopwatch.stop();
                      stopwatch.reset();
                    });
                  },
                  child: Text('get palette'),
                ),

                if (palette.length > 0)
                  Text('Elapsed: $elapsed'),

                if (palette.length > 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: List.generate(numPaletteColors, (index) =>
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 30,
                                color: palette.elementAt(index).color,
                              ),
                              SizedBox(width: 10),
                              Text('${palette.elementAt(index).color}   '
                                  '${palette.elementAt(index).percentage.toStringAsFixed(2)}%'),
                            ],
                          )
                      ),
                    ),
                  )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
