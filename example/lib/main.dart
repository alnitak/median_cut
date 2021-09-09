import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;
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
  int numPaletteColors = 10;

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
                    child: Image.asset('assets/landscape-scene.jpeg',
                        fit: BoxFit.scaleDown)),

                /// buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        stopwatch.start();
                        final ByteData assetImageByteData = await rootBundle
                            .load('assets/landscape-scene.jpeg');
                        image.Image? baseSizeImage = image.decodeImage(
                            assetImageByteData.buffer.asUint8List());
                        Uint8List imgBuffer = baseSizeImage!.getBytes();

                        MedianCut.medianCut(numPaletteColors, imgBuffer)
                            .then((value) {
                          palette = value;
                          setState(() {
                            elapsed = stopwatch.elapsed;
                            stopwatch.stop();
                            stopwatch.reset();
                          });
                        });
                      },
                      child: Text('get palette'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          palette.sort((a, b) {
                            return a.luminance > b.luminance
                                ? 1
                                : a.luminance == b.luminance
                                    ? 0
                                    : -1;
                          });
                          setState(() {});
                        },
                        child: Text('luminance sort')),
                    ElevatedButton(
                        onPressed: () {
                          palette.sort((a, b) {
                            return a.percentage > b.percentage
                                ? 1
                                : a.percentage == b.percentage
                                    ? 0
                                    : -1;
                          });
                          setState(() {});
                        },
                        child: Text('% sort'))
                  ],
                ),

                /// draw samples color values
                if (palette.length > 0) Text('Elapsed: $elapsed'),

                /// draw samples colors
                if (palette.length > 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: List.generate(numPaletteColors, (index) {
                        String color =
                            palette.elementAt(index).color.toString();
                        String percentage = palette
                            .elementAt(index)
                            .percentage
                            .toStringAsFixed(2);
                        return Row(
                          children: [
                            Container(
                              width: 60,
                              height: 30,
                              color: palette.elementAt(index).color,
                            ),
                            SizedBox(width: 10),
                            Text('$color  $percentage%'),
                          ],
                        );
                      }),
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
