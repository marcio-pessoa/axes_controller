import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/static/comm_status.dart';

String hintText(BuildContext context, String serverName, CommStatus status) {
  String result = AppLocalizations.of(context)!.unknown;
  switch (status) {
    case CommStatus.connected:
      result = "${AppLocalizations.of(context)!.typeMessage} $serverName";
      break;
    case CommStatus.connecting:
      result = AppLocalizations.of(context)!.waitConnection;
      break;
    case CommStatus.disconnected:
      result = AppLocalizations.of(context)!.chatDetached;
      break;
    case CommStatus.disconnecting:
      result = AppLocalizations.of(context)!.unknown;
      break;
  }
  return result;
}
