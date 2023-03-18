import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/cubit/comm_state.dart';
import 'package:xc/static/end_line.dart';

class CommCubit extends Cubit<CommState> {
  CommCubit()
      : super(CommState(
          endLine: EndLine.lf,
        ));

  void set({
    endLine,
  }) {
    endLine = endLine ?? state.endLine;

    final update = CommState(
      endLine: endLine,
    );

    emit(update);
  }
}
