import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xc/cubit/comm_state.dart';
import 'package:xc/static/comm_interface.dart';
import 'package:xc/static/end_line.dart';

class CommCubit extends HydratedCubit<CommState> {
  CommCubit()
      : super(CommState(
          endLine: EndLine.lf,
          interface: CommInterface.bluetooth,
        ));

  void set({
    endLine,
    interface,
  }) {
    endLine = endLine ?? state.endLine;
    interface = interface ?? state.interface;

    final update = CommState(
      endLine: endLine,
      interface: interface,
    );

    emit(update);
  }

  @override
  CommState? fromJson(Map<String, dynamic> json) {
    String endLine = json['endLine'] ?? 'lf';
    String interface = json['interface'] ?? 'Bluetooth';
    return CommState(
      endLine: toEndLine(endLine),
      interface: toCommInterface(interface),
    );
  }

  @override
  Map<String, dynamic>? toJson(CommState state) {
    return {
      'endLine': state.endLine.name,
      'interface': state.interface.description
    };
  }
}
