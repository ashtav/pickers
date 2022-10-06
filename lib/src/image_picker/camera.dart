import 'dart:html';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mixins/mixins.dart';
import 'package:pickers/src/constant_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  CameraController? controller;

  Future initCamera() async {
    try {
      cameras = await availableCameras();
      controller = CameraController(cameras[0], ResolutionPreset.medium);

      controller?.initialize().then((_) {
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print('User denied camera access.');
              break;
            default:
              print('Handle other errors.');
              break;
          }
        }
      });
    } catch (_) {}
  }

  Future capture() async {
    try {
      final XFile? xfile = await controller?.takePicture();

      if (xfile != null) {
        File file = File([xfile.path], 'image/jpeg');
      }
    } catch (_) {}
  }

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: controller?.value == null
          ? Container()
          : Stack(
              children: [
                SizedBox(
                  height: context.h,
                  child: CameraPreview(controller!),
                ),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: Ei.only(b: 25),
                    child: Intrinsic(
                      children: List.generate(3, (index) {
                        List<Widget> widgets = [
                          InkW(
                            onTap: () => Navigator.pop(context),
                            child: Iconr(
                              Ti.chevron_left,
                              color: Colors.white,
                              padding: Ei.all(15),
                            ),
                          ),
                          FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () => capture(),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Br.all(Colors.black, width: 2)),
                            ),
                          ),
                          const None()
                        ];

                        return Expanded(child: widgets[index]);
                      }),
                    ),
                  ),
                ))
              ],
            ),
    );
  }
}
