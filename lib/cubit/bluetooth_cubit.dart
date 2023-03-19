import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:xc/cubit/bluetooth_state.dart';

class BluetoothCubit extends Cubit<MyBluetoothState> {
  BluetoothCubit()
      : super(
          MyBluetoothState(
            connection: const BluetoothDevice(address: ''),
            defaultPassword: '1234',
          ),
        );

  void set({connection, defaultPassword}) {
    connection = connection ?? state.connection;
    defaultPassword = defaultPassword ?? state.defaultPassword;

    final update = MyBluetoothState(
      connection: connection,
      defaultPassword: defaultPassword,
    );

    emit(update);
  }
}
