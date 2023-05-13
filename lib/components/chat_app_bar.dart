import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/components/comm_status_icon.dart';
import 'package:xc/static/comm_status.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CommStatus status;
  final Function()? clearDialog;

  const ChatAppBar({
    super.key,
    required this.status,
    this.clearDialog,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: (Text(AppLocalizations.of(context)!.chat)),
      actions: <Widget>[
        CommStatusIcon(status: status),
        IconButton(
          icon: const Icon(Icons.speaker_notes_off_outlined),
          onPressed: clearDialog,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
