import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaquby/config.dart';

class CurrentDateTimeWidget extends StatefulWidget {
  const CurrentDateTimeWidget({Key? key});

  @override
  _CurrentDateTimeWidgetState createState() => _CurrentDateTimeWidgetState();
}

class _CurrentDateTimeWidgetState extends State<CurrentDateTimeWidget> {
  late Timer _timer;
  String currentTime = '';
  String currentDate = '';

  @override
  void initState() {
    super.initState();
    getCurrentDateTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    setState(() {
      currentTime = formattedTime;
      currentDate = formattedDate;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      getCurrentDateTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
      child: Container(
        color: Colors.blueGrey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              currentDate,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
              ),
            ),
            Text(
              currentTime,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
