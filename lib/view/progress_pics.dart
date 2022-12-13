import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:project_cut/controller/progress_pics_controller.dart';
import 'package:project_cut/model/progress_pic.dart';
import 'package:provider/provider.dart';

class ProgressPictures extends StatefulWidget {
  const ProgressPictures({Key? key}) : super(key: key);

  @override
  State<ProgressPictures> createState() => _ProgressPicturesState();
}

class _ProgressPicturesState extends State<ProgressPictures> {
  late Future _progressPicsFuture;

  @override
  void initState() {
    super.initState();
    _progressPicsFuture = _loadProgressPics();
  }

  Future _loadProgressPics() async {
    await Provider.of<ProgressPicsController>(context, listen: false)
        .setProgressPictures();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _progressPicsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<ProgressPicsController>(
            builder: (context, picProvider, child) {
              List<ProgressPicture> progressPictures =
                  picProvider.progressPictures;
              Directory directory = picProvider.directory;
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
                  itemCount: progressPictures.length,
                  itemBuilder: (context, index) {
                    ProgressPicture progressPicture = progressPictures[index];
                    return Card(
                      child: Image.file(
                        File('${directory.path}/${progressPicture.imagePath}'),
                      ),
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => TakeProgressPic(
                    //       picProvider: picProvider,
                    //     ),
                    //   ),
                    // );
                    XFile? takenImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);

                    if (takenImage != null) {
                      Directory directory =
                          await getApplicationDocumentsDirectory();

                      File image = File(takenImage.path);

                      String imageName = path.basename(takenImage.path);

                      File savedImage =
                          await image.copy('${directory.path}/$imageName');

                      picProvider.addImagePathToDb(imageName);
                    }
                  },
                  child: const Icon(Icons.add_a_photo_rounded),
                ),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
