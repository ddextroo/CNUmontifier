import 'dart:async';
import 'dart:typed_data';
import 'package:cnumontifier/widgets/CustomText.dart';
import 'package:cnumontifier/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late CameraController cameraController;
  bool initialized = false;
  bool isWorking = false;
  String? prediction;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission().then((_) {
      initialize();
    });
  }

  Future<void> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();
      status = statuses[Permission.camera]!;
    }

    if (status.isGranted) {
      // Permission granted, proceed with camera access.
    } else {
      // Permission denied, handle accordingly.
    }
  }

  Future<void> initialize() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );
    await cameraController.initialize();
    await cameraController.startImageStream((image) {
      if (!isWorking) {
        processCameraImage(image);
      }
    });
    setState(() {
      initialized = true;
    });
  }

  Future<void> processCameraImage(CameraImage cameraImage) async {
    setState(() {
      isWorking = true;
    });

    img.Image image = convertCameraImage(cameraImage);
    prediction = await classifyImage(image);

    setState(() {
      isWorking = false;
    });
  }

  img.Image convertCameraImage(CameraImage cameraImage) {
    // Convert the CameraImage to an img.Image
    // This step depends on the format your model expects
    // For demonstration, we'll return a dummy image
    return img.Image(150, 150);
  }

  Future<String> classifyImage(img.Image image) async {
    // Load the model
    Interpreter interpreter =
        await Interpreter.fromAsset('assets/tensorflow/model_unquant.tflite');

    // Preprocess the image
    img.Image resizedImage = img.copyResize(image, width: 150, height: 150);
    Float32List inputBytes = Float32List(1 * 150 * 150 * 3);
    int pixelIndex = 0;
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        int pixel = resizedImage.getPixel(x, y);
        inputBytes[pixelIndex++] = img.getRed(pixel) / 127.5 - 1.0;
        inputBytes[pixelIndex++] = img.getGreen(pixel) / 127.5 - 1.0;
        inputBytes[pixelIndex++] = img.getBlue(pixel) / 127.5 - 1.0;
      }
    }

    // Run the model
    final input = inputBytes.reshape([1, 150, 150, 3]);
    final output = Float32List(1 * 4).reshape([1, 4]);
    interpreter.run(input, output);

    // Postprocess the output
    final predictionResult = output[0] as List<double>;
    double maxElement = predictionResult.reduce(
        (double maxElement, double element) =>
            element > maxElement ? element : maxElement);
    int index = predictionResult.indexOf(maxElement);

    // Return the label of the predicted object
    // This assumes you have a list of labels in the same order as your model's output
    List<String> labels = ['CEBUENSE', 'MINDANAENSE'];
    //0 CEBUENSE
    //1 MINDANAENSE

    return labels[index];
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      return Container();
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
          child: SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
        ),
      body: Stack(
        children: <Widget>[
          CameraPreview(cameraController),
          Center(
            child: CustomText(
              text: prediction ?? 'No prediction',
              fontSize: 14,
              textAlign: TextAlign.center,
              color: ColorTheme.textColorLight,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
