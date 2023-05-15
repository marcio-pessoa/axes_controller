import 'package:flutter/material.dart';
import 'package:xc/static/comm_status.dart';

class CommStatusIcon extends StatelessWidget {
  final CommStatus status;

  const CommStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Widget icon = const Icon(Icons.circle_outlined, color: Colors.grey);

    switch (status) {
      case CommStatus.connected:
        icon = const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
        );
        break;
      case CommStatus.connecting:
        icon = Stack(children: [
          Icon(
            Icons.swap_vertical_circle_outlined,
            color: Colors.grey[700],
          ),
          const Blinker(
            child: Icon(
              Icons.swap_vertical_circle_outlined,
              color: Colors.yellow,
            ),
          ),
        ]);
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

class Blinker extends StatefulWidget {
  final Widget child;

  const Blinker({super.key, required this.child});

  @override
  State<Blinker> createState() => _BlinkerState();
}

class _BlinkerState extends State<Blinker> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }
}
