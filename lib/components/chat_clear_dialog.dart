import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/cubit/chat_cubit.dart';
import 'package:xc/static/colors.dart';

Future<void> clearChatDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.chatClear),
        content: Text(AppLocalizations.of(context)!.chatClearConfirm),
        actions: <Widget>[
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.yes,
              style: const TextStyle(color: MyColors.alert),
            ),
            onPressed: () {
              final chat = context.read<ChatCubit>();
              chat.clear();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.no),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
