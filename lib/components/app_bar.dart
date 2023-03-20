import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    required this.actions,
    this.leading,
  })  : prefeeredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Size prefeeredSize;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xFF011627),
      actions: widget.actions,
      leading: widget.leading,
      title: Text(
        widget.title,
        style: GoogleFonts.jost(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
