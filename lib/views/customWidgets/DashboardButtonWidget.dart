import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaquby/config.dart';
 

class DashboardButtonWidget extends StatefulWidget {
  final String iconPath;
  final String label;
  final Color color;
  final Color iconColor;
  final Color textColor;
  final VoidCallback? onPressed;

  const DashboardButtonWidget({
    Key? key,
    required this.iconPath,
    required this.label,
    required this.color,
    required this.iconColor,
    required this.textColor,
    this.onPressed,
  }) : super(key: key);

  @override
  State<DashboardButtonWidget> createState() => _DashboardButtonWidgetState();
}

class _DashboardButtonWidgetState extends State<DashboardButtonWidget> {

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    if (widget.iconPath.endsWith('.svg')) {
      iconWidget = SvgPicture.asset(
        widget.iconPath,
        height: 40,
        color: widget.iconColor,
      );
    } else if (widget.iconPath.endsWith('.png')) {
      iconWidget = Image.asset(
        widget.iconPath,
        height: 40,
        color: widget.iconColor,
      );
    } else {
      iconWidget = Container(); // Placeholder if the file type is unsupported
    }

    return Material(
      color: Colors.transparent,
      // ignore: sized_box_for_whitespace
      child: Container(
        height: 100, // Set the desired height
        width: 100, // Set the desired width
        child: InkWell(
          onTap: widget.onPressed,
          splashColor: AppColors.textColor5,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  iconWidget,
                  const Spacer(),
                  Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
