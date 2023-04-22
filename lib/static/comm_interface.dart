enum CommInterface {
  serial,
  bluetooth,
}

extension CommInterfaceExtension on CommInterface {
  String get name {
    switch (this) {
      case CommInterface.bluetooth:
        return "Bluetooth";
      case CommInterface.serial:
        return "Serial";
    }
  }
}

CommInterface toCommInterface(name) {
  switch (name) {
    case "Bluetooth":
      return CommInterface.bluetooth;
    case "Serial":
      return CommInterface.serial;
    default:
      return CommInterface.bluetooth;
  }
}
