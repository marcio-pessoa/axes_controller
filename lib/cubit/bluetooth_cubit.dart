import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:xc/cubit/bluetooth_state.dart';

class BluetoothCubit extends Cubit<MyBluetoothState> {
  BluetoothCubit()
      : super(
          MyBluetoothState(
            connection: const BluetoothDevice(address: ''),
            defaultPassword: '1234',
            autoPairing: false,
          ),
        );

  void set({connection, defaultPassword, autoPairing}) {
    connection = connection ?? state.connection;
    defaultPassword = defaultPassword ?? state.defaultPassword;
    autoPairing = autoPairing ?? state.autoPairing;

    final update = MyBluetoothState(
      connection: connection,
      defaultPassword: defaultPassword,
      autoPairing: autoPairing,
    );

    emit(update);
  }
}
