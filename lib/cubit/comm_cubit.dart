import 'dart:developer';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xc/cubit/comm_state.dart';
import 'package:xc/static/end_line.dart';

class CommCubit extends HydratedCubit<CommState> {
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

  @override
  CommState? fromJson(Map<String, dynamic> json) {
    log('Inside fromJson...');
    String endLine = json['endLine'] ?? 'lf';
    return CommState(endLine: toEndLine(endLine));
  }

  @override
  Map<String, dynamic>? toJson(CommState state) {
    log('Inside toJson...');
    return {'endLine': state.endLine.name};
  }
}
