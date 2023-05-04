import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

Future<void> scrollFollow(ScrollController listScrollController) async {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    const int duration = 400;

    listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: duration),
        curve: Curves.easeInOut);
  });
}
