import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:leadee/screens/gallery.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({
    super.key,
    required this.cameras,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late Future<void> _initializeControllerFuture;
  late CameraController _controller;
  int _selectedCameraIndex = -1;
  String? _lastImage;
  bool _loading = false;

  Future<void> initCamera(CameraDescription camera) async {
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (_controller.value.hasError) {
      print("Camera error ${_controller.value.errorDescription}");
    }

    _initializeControllerFuture = _controller.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _cameraToggle() async {
    if (_lastImage != null) {
      _lastImage = null;
    }

    setState(() {
      _selectedCameraIndex = _selectedCameraIndex > -1
          ? _selectedCameraIndex == 0
              ? 1
              : 0
          : 0;
    });
    await initCamera(widget.cameras[_selectedCameraIndex]);
  }

  Future<void> _takePhoto() async {
    try {
      await _initializeControllerFuture;

      // final String pathImage = join((await getTemporaryDirectory()).path,
      //     "${DateTime.now().millisecondsSinceEpoch}.png");

      final XFile pathTakePicture = await _controller.takePicture();

      // print("pathTakePicture : ");
      // print(pathTakePicture.path);
      // print("## FINISH ##");
      // print("path : $pathImage");

      setState(() {
        _lastImage = pathTakePicture.path;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    _cameraToggle();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: _lastImage != null
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() {
                    _lastImage = null;
                  }),
                )
              : null,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      child: _lastImage != null
                          ? Image(
                              fit: BoxFit.cover,
                              height: size.height,
                              width: size.width,
                              image: FileImage(
                                File(_lastImage!),
                              ),
                            )
                          : SizedBox(
                              height: size.height,
                              width: size.width,
                              child: CameraPreview(_controller),
                            ),
                    ),
                    Visibility(
                      visible: _lastImage == null,
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 200.0,
                          bottom: 50.0,
                        ),
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        child: FutureBuilder(
                            future: StoragePath.imagesPath,
                            builder: (context, snapshot) {
                              List<dynamic> images = [];

                              Widget defaultwidget = const Icon(
                                Icons.photo_library_outlined,
                                color: Colors.white,
                                size: 30.0,
                              );

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                images = jsonDecode(snapshot.data!);

                                if (images.isNotEmpty &&
                                    images[0]["files"].length > 0) {
                                  defaultwidget = CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: FileImage(
                                      File(images[0]["files"][0]),
                                    ),
                                  );
                                }
                              }

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () async {
                                    dynamic data = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            GalleryScreen(images: images)),
                                      ),
                                    );

                                    setState(() => _lastImage =
                                        data != null ? data["path"] : null);
                                  },
                                  child: defaultwidget,
                                ),
                              );
                            }),
                      ),
                    ),
                    Visibility(
                      visible: _lastImage == null,
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 200.0,
                          bottom: 50.0,
                        ),
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: _cameraToggle,
                            child: const Icon(
                              Icons.loop_outlined,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _lastImage != null && _loading == true,
                      child: const Positioned(
                        bottom: 30.0,
                        left: 20.0,
                        child: Row(
                          children: [
                            SpinKitThreeBounce(
                              color: Colors.white,
                              size: 12.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              "Publishing",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        floatingActionButton: _lastImage == null
            ? Container(
                margin: const EdgeInsets.only(
                  bottom: 20.0,
                ),
                width: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3.0,
                  ),
                ),
                child: FittedBox(
                  child: InkWell(
                    onLongPress: () => print("take video"),
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      onPressed: _takePhoto,
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                    ),
                  ),
                ),
              )
            : FloatingActionButton.extended(
                elevation: 0.0,
                shape: const RoundedRectangleBorder(),
                backgroundColor: Colors.white.withOpacity(0.6),
                onPressed: () async {
                  setState(() => _loading = !_loading);

                  await Future.delayed(const Duration(seconds: 3));

                  setState(() => _lastImage = null);
                  setState(() => _loading = !_loading);
                },
                label: Text(
                  "publish".toUpperCase(),
                  style: const TextStyle(color: Colors.black),
                ),
                icon: const Icon(
                  Icons.send_outlined,
                  color: Colors.black,
                ),
              ),
        floatingActionButtonLocation: _lastImage == null
            ? FloatingActionButtonLocation.centerFloat
            : FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
