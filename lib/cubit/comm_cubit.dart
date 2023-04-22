import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xc/cubit/comm_state.dart';
import 'package:xc/static/comm_interface.dart';
import 'package:xc/static/end_line.dart';

class CommCubit extends HydratedCubit<CommState> {
  CommCubit()
      : super(CommState(
          endLine: EndLine.lf,
          commInterface: CommInterface.bluetooth,
        ));

  void set({
    endLine,
    commInterface,
  }) {
    endLine = endLine ?? state.endLine;
    commInterface = commInterface ?? state.commInterface;

    final update = CommState(
      endLine: endLine,
      commInterface: commInterface,
    );

    emit(update);
  }

  @override
  CommState? fromJson(Map<String, dynamic> json) {
    String endLine = json['endLine'] ?? 'lf';
    String commInterface = json['commInterface'] ?? 'Bluetooth';
    return CommState(
      endLine: toEndLine(endLine),
      commInterface: toCommInterface(commInterface),
    );
  }

  @override
  Map<String, dynamic>? toJson(CommState state) {
    return {'endLine': state.endLine.name};
  }
}
