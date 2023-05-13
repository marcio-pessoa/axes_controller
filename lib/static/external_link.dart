enum ExternalLink {
  github,
}

extension BaudRateExtension on ExternalLink {
  Uri get uri {
    switch (this) {
      case ExternalLink.github:
        return Uri.parse('https://github.com/marcio-pessoa/axes_controller');
    }
  }
}
