import 'package:flutter/material.dart';
import 'package:xc/static/comm_status.dart';

class CommStatusIcon extends StatelessWidget {
  final CommStatus status;

  const CommStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Widget icon = const Icon(
      Icons.circle_outlined,
      color: Colors.grey,
    );

    switch (status) {
      case CommStatus.connected:
        icon = const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
        );
        break;
      case CommStatus.connecting:
        icon = const Padding(
          padding: EdgeInsets.fromLTRB(0.0, 8.0, 4.0, 8.0),
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
        break;
      case CommStatus.disconnected:
        icon = const Icon(
          Icons.cancel_outlined,
          color: Colors.red,
        );
        break;
      case CommStatus.disconnecting:
        icon = const Icon(
          Icons.cancel_outlined,
          color: Colors.orange,
        );
        break;
    }
    return icon;
  }
}
