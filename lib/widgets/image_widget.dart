import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

import '../Utils/colors.dart';

showFullImageWidget(BuildContext context, String img) {
  return showImageViewer(
      context,
      CachedNetworkImageProvider(
          img,
          maxWidth: int.parse('${(MediaQuery.of(context).size.width*0.95).round()}')
      ),
      backgroundColor: kWhite,
      closeButtonColor: kBlack,
      useSafeArea: true,
      swipeDismissible: true,
      doubleTapZoomable: true);
}
