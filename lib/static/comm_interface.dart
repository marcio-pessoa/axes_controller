enum CommInterface {
  serial,
  bluetooth,
}

extension CommInterfaceExtension on CommInterface {
  String get description {
    switch (this) {
      case CommInterface.bluetooth:
        return "Bluetooth";
      case CommInterface.serial:
        return "Serial";
    }
  }
}

CommInterface toCommInterface(description) {
  switch (description) {
    case "Bluetooth":
      return CommInterface.bluetooth;
    case "Serial":
      return CommInterface.serial;
    default:
      return CommInterface.bluetooth;
  }
}
