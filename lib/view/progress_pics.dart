import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ProgressPictures extends StatelessWidget {
  const ProgressPictures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Progress Pics",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            child: Text('Image Stuff'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: '/progress_pics'),
              builder: (context) => const TakeProgressPic(),
            ),
          );
        },
        child: const Icon(Icons.add_a_photo_rounded),
      ),
    );
  }
}

class TakeProgressPic extends StatefulWidget {
  const TakeProgressPic({super.key});

  @override
  State<TakeProgressPic> createState() => _TakeProgressPicState();
}

class _TakeProgressPicState extends State<TakeProgressPic> {
  late CameraDescription _camera;
  late CameraController _cameraController;
  late Future _cameraFuture;

  @override
  void initState() {
    super.initState();
    _cameraFuture = _getCameras();
  }

  @override
  void dispose() {
    // TODO: Dispose of controllers
    _cameraController.dispose();
    super.dispose();
  }

  Future _getCameras() async {
    List<CameraDescription> cameras = await availableCameras();
    _camera = cameras.first;
    _cameraController = CameraController(_camera, ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Take a Progress Pic",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: FutureBuilder(
        future: _cameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _cameraFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _cameraController.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                settings: const RouteSettings(name: '/take_picture'),
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Happy with this angle?",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: [
          Image.file(File(imagePath)),
          Row(
            children: [
              MaterialButton(
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((route) => count++ == 2);
                },
                child: const Text('Save'),
              ),
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Take Again'),
              )
            ],
          )
        ],
      ),
    );
  }
}
