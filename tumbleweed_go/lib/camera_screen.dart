import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'util.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            _cameraPreviewWidget(),
            Align(
              alignment: isLoading ? Alignment.center : Alignment.bottomCenter,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: EdgeInsets.all(16.0),
                      child: FloatingActionButton(
                          child: Icon(Icons.camera),
                          backgroundColor: Colors.blueGrey,
                          onPressed: () {
                            _onCapturePressed(context);
                          }),
                    ),
            )
          ]),
    );
  }

  /// Display Camera preview.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  void _onCapturePressed(context) async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Attempt to take a picture and log where it's been saved
      final path = join(
        // In this example, store the picture in the temp directory. Find
        // the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      print(path);
      await controller.takePicture(path);

      ApiAccessor.uploadImage(path).then((status) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        if (status == 200) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                  title: Text('Nice find!'),
                  content:
                      Text('We\'ve added the tumbleweed to our database.')),
              barrierDismissible: true);
        } else {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Whoops!'),
                    content: Text(
                        'We couldn\'t find a tumbleweed in the image you took.'),
                  ),
              barrierDismissible: true);
        }
      });

      setState(() {
        isLoading = true;
      });
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    print('Error: ${e.code}\n${e.description}');
  }
}
