import 'package:flutter/material.dart';
import '../../data/constants.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true, // Deaktiviere den Pfeil zurück
      title: const Text(Constants.appName),
    );
  }
}