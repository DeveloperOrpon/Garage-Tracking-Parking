import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FullScreenPage extends StatelessWidget {
  const FullScreenPage({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: imageUrl,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: Get.height,
          width: Get.width,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveImage(imageUrl, context);
        },
        child: Icon(Icons.download_for_offline),
      ),
    );
  }

  _saveImage(String url, BuildContext context) async {
    try {

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Image Saved In Galary"),
        backgroundColor: Colors.orange,
      ));
    } catch (error) {
      log(error.toString());
    }
  }
}
