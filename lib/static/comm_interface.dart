enum CommInterface {
  usb,
  bluetooth,
}

extension CommInterfaceExtension on CommInterface {
  String get description {
    switch (this) {
      case CommInterface.bluetooth:
        return "Bluetooth";
      case CommInterface.usb:
        return "USB";
    }
  }
}

CommInterface toCommInterface(description) {
  switch (description) {
    case "Bluetooth":
      return CommInterface.bluetooth;
    case "USB":
      return CommInterface.usb;
    default:
      return CommInterface.bluetooth;
  }
}
