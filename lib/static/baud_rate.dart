enum BaudRate {
  baud1200,
  baud2400,
  baud4800,
  baud9600,
  baud19200,
  baud38400,
  baud57600,
  baud115200,
}

extension BaudRateExtension on BaudRate {
  String get description {
    switch (this) {
      case BaudRate.baud1200:
        return "1200";
      case BaudRate.baud2400:
        return "2400";
      case BaudRate.baud4800:
        return "4800";
      case BaudRate.baud9600:
        return "9600";
      case BaudRate.baud19200:
        return "19200";
      case BaudRate.baud38400:
        return "38400";
      case BaudRate.baud57600:
        return "57600";
      case BaudRate.baud115200:
        return "115200";
    }
  }
}

BaudRate toBaudRate(description) {
  switch (description) {
    case "1200":
      return BaudRate.baud1200;
    case "2400":
      return BaudRate.baud9600;
    case "4800":
      return BaudRate.baud4800;
    case "9600":
      return BaudRate.baud9600;
    case "19200":
      return BaudRate.baud19200;
    case "38400":
      return BaudRate.baud38400;
    case "57600":
      return BaudRate.baud57600;
    case "115200":
      return BaudRate.baud115200;
    default:
      return BaudRate.baud115200;
  }
}
