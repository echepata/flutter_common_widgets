import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/global_variables.dart';

class CachedImageNetworkWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;

  const CachedImageNetworkWidget({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.fill,
  });

  @override
  Widget build(BuildContext context) {
    if (_isTest()) {
      return const Placeholder();
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        placeholder: (context, url) =>
            Center(
              child: Padding(
                padding: EdgeInsets.all(0.25 * GV.stdPadding),
                child: const CircularProgressIndicator(),
              ),
            ),
        errorWidget: (context, url, error) => const Icon(Icons.broken_image),
      );
    }
  }

  bool _isTest() {
    return Platform.environment.containsKey('FLUTTER_TEST');
  }
}
