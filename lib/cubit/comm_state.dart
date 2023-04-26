import 'package:xc/static/comm_interface.dart';
import 'package:xc/static/end_line.dart';

class CommState {
  final EndLine endLine;
  final CommInterface interface;
  final String? address;

  CommState({
    required this.endLine,
    required this.interface,
    required this.address,
  });
}
