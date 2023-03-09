import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/colors.dart';

Future<bool> exitDialog(BuildContext context) async {
  final result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('${AppLocalizations.of(context)!.exit}?'),
        content: Text(AppLocalizations.of(context)!.areYouShure),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.no),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.yes,
              style: const TextStyle(color: MyColors.alert),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    },
  );
  return result;
}
