import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class GalleryScreen extends StatefulWidget {
  final List<dynamic> images;

  const GalleryScreen({
    super.key,
    required this.images,
  });

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          titleSpacing: 0.0,
          title: const Text('Gallery'),
        ),
        body: GridView.builder(
          itemCount: widget.images[0]["files"].length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemBuilder: (context, index) => InkWell(
            onTap: () => Navigator.pop(
                context, {"path": widget.images[0]["files"][index]}),
            child: FadeInImage(
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              placeholder: MemoryImage(kTransparentImage),
              image: FileImage(
                File(
                  widget.images[0]["files"][index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
