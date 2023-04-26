import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/select_bonded_device_page.dart';
import 'package:xc/cubit/comm_cubit.dart';
import 'package:xc/screens/device_select/usb.dart';
import 'package:xc/static/comm_interface.dart';

class DeviceSelect extends StatelessWidget {
  const DeviceSelect({super.key});

  @override
  Widget build(BuildContext context) {
    final communication = context.read<CommCubit>();

    switch (communication.state.interface) {
      case CommInterface.bluetooth:
        return const SelectBondedDevicePage(checkAvailability: false);
      case CommInterface.usb:
        return const DeviceSelectUSB();
      default:
        return Container();
    }
  }
}
