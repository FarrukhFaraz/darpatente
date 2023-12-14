
import 'package:flutter/material.dart';

 showActionMenuWidget(BuildContext context) {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

  final menuItems = [
    const PopupMenuItem(
      value: 'about',
      child: Text('About Us'),
    ),
    const PopupMenuItem(
      value: 'privacy',
      child: Text('Privacy Policy'),
    ),
  ];

  showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    ),
    items: menuItems,
  ).then((value) {
    // Handle menu item selection
    if (value == 'about') {
      // Perform action for About Us
      print('About Us selected');
    } else if (value == 'privacy') {
      // Perform action for Privacy Policy
      print('Privacy Policy selected');
    }
  });
}