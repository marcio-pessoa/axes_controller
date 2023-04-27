import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xc/cubit/comm_state.dart';
import 'package:xc/static/comm_interface.dart';
import 'package:xc/static/end_line.dart';

class CommCubit extends HydratedCubit<CommState> {
  CommCubit()
      : super(CommState(
          endLine: EndLine.lf,
          interface: CommInterface.bluetooth,
          address: null,
        ));

  void set({
    endLine,
    interface,
    address,
  }) {
    endLine = endLine ?? state.endLine;
    interface = interface ?? state.interface;
    address = address ?? state.address;

    final update = CommState(
      endLine: endLine,
      interface: interface,
      address: address,
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
      address: json['address'].toString(),
    );
  }

  @override
  Map<String, dynamic>? toJson(CommState state) {
    return {
      'endLine': state.endLine.name,
      'interface': state.interface.description,
      'address': state.address.toString(),
    };
  }
}
