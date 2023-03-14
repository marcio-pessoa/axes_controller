import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:xc/cubit/bluetooth_state.dart';

class BluetoothCubit extends Cubit<MyBluetoothState> {
  BluetoothCubit()
      : super(
          MyBluetoothState(connection: const BluetoothDevice(address: '')),
        );

  void set({connection}) {
    connection = connection ?? state.connection;

    final update = MyBluetoothState(
      connection: connection,
    );

    emit(update);
  }
}
