import 'package:xc/static/comm_interface.dart';
import 'package:xc/static/end_line.dart';

class CommState {
  final EndLine endLine;
  final CommInterface interface;

  CommState({
    required this.endLine,
    required this.interface,
  });
}
