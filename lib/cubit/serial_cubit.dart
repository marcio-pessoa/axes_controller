import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xc/cubit/serial_state.dart';
import 'package:xc/static/baud_rate.dart';

class SerialCubit extends HydratedCubit<SerialState> {
  SerialCubit()
      : super(
          SerialState(
            baudRate: BaudRate.baud115200,
            address: null,
          ),
        );

  void set({baudRate, address}) {
    baudRate = baudRate ?? state.baudRate;

    final update = SerialState(
      baudRate: baudRate,
      address: address,
    );

    emit(update);
  }

  @override
  SerialState? fromJson(Map<String, dynamic> json) {
    String baudRate = json['baudRate'] ?? '115200';
    String address = json['address'];

    return SerialState(
      baudRate: toBaudRate(baudRate),
      address: address,
    );
  }

  @override
  Map<String, dynamic>? toJson(SerialState state) {
    return {'baudRate': state.baudRate.description, 'address': state.address};
  }
}
