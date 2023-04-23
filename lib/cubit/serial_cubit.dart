import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xc/cubit/serial_state.dart';
import 'package:xc/static/baud_rate.dart';

class SerialCubit extends HydratedCubit<SerialState> {
  SerialCubit()
      : super(
          SerialState(
            baudRate: BaudRate.baud115200,
          ),
        );

  void set({baudRate}) {
    baudRate = baudRate ?? state.baudRate;

    final update = SerialState(
      baudRate: baudRate,
    );

    emit(update);
  }

  @override
  SerialState? fromJson(Map<String, dynamic> json) {
    String baudRate = json['baudRate'] ?? '115200';
    return SerialState(
      baudRate: toBaudRate(baudRate),
    );
  }

  @override
  Map<String, dynamic>? toJson(SerialState state) {
    return {
      'baudRate': state.baudRate.description,
    };
  }
}
