import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_cut/controller/progress_pics_controller.dart';
import 'package:project_cut/model/biometric.dart';
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
              List<Biometric> biometrics = picProvider.biometrics;
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
                    Biometric biometric = biometrics
                        .where(
                          (element) =>
                              element.id == progressPicture.biometricId,
                        )
                        .first;

                    DateFormat dateformatter = DateFormat('d MMMM y');
                    String formattedDate = dateformatter
                        .format(DateTime.parse(biometric.dateTime));

                    String formattedWeight = "${biometric.currentWeight}kg";

                    return Column(
                      children: [
                        index == 0 ||
                                progressPicture.biometricId !=
                                    progressPictures[index - 1].biometricId
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(32, 32, 32, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "$formattedDate - $formattedWeight",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  File(
                                      '${directory.path}/${progressPicture.imagePath}'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FloatingActionButton(
                                  heroTag: 'delete ${progressPicture.id}',
                                  mini: true,
                                  onPressed: () =>
                                      picProvider.deleteProgressPicture(
                                          progressPicture.id!),
                                  backgroundColor: Colors.white38,
                                  elevation: 0,
                                  child: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                floatingActionButton: Wrap(
                  direction: Axis.horizontal,
                  spacing: 8,
                  children: [
                    FloatingActionButton(
                      heroTag: 'gallery',
                      onPressed: () async {
                        XFile? takenImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);

                        if (takenImage != null) {
                          picProvider.addImagePathToDb(takenImage.path);
                        }
                      },
                      child: const Icon(Icons.image),
                    ),
                    FloatingActionButton(
                      heroTag: 'camera',
                      onPressed: () async {
                        XFile? takenImage = await ImagePicker()
                            .pickImage(source: ImageSource.camera);

                        if (takenImage != null) {
                          picProvider.addImagePathToDb(takenImage.path);
                        }
                      },
                      child: const Icon(Icons.add_a_photo_rounded),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
