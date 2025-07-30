import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class DrawerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AdvancedDrawerController drawerController;
  final List<Widget>? actions;

  const DrawerAppBar({
    Key? key,
    required this.title,
    required this.drawerController,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          drawerController.showDrawer();
        },
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
