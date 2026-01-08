import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    status = await Permission.camera.request();
  }
  return status.isGranted;
}

Future<void> openCamera(BuildContext context) async {
  bool granted = await requestCameraPermission();
  if (!granted) {
    print("Camera permission denied");
    return;
  }

  final cameras = await availableCameras();
  if (cameras.isEmpty) {
    print("No camera found");
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TakePictureScreen(cameras: cameras),
    ),
  );
}

class TakePictureScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const TakePictureScreen({required this.cameras, super.key});

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int _currentCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera(_currentCameraIndex);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _initializeCamera(int index) {
    _controller = CameraController(
      widget.cameras[index],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller.dispose();
    super.dispose();
  }

  void _switchCamera() {
    if (widget.cameras.length < 2) return;
    _currentCameraIndex = (_currentCameraIndex + 1) % widget.cameras.length;
    _controller.dispose();
    _initializeCamera(_currentCameraIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox.expand(child: CameraPreview(_controller)),

                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: Icon(
                      Icons.cameraswitch,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _switchCamera,
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
