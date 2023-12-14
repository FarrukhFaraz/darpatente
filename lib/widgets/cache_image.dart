import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_widget.dart';

Widget cacheImage(BuildContext context, String img) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: InkWell(
      onTap: () {
        showFullImageWidget(context, img);
      },
      child: CachedNetworkImage(
        fit: BoxFit.contain,
        imageUrl: img,
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
          height: 150,
          child: Center(
            child: CircularProgressIndicator(value: downloadProgress.progress),
          ),
        ),
        errorWidget: (context, url, error) {
          print('error:::::${error}');
          return const Center(
            child: Tooltip(
              message: 'error in fetching image',
              showDuration: Duration(seconds: 2),
              triggerMode: TooltipTriggerMode.tap,
              enableFeedback: true,
              child: Icon(
                Icons.info,
                size: 40,
              ),
            ),
          );
        },
      ),
    ),
  );
}
