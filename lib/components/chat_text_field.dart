import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xc/static/colors.dart';
import 'package:xc/static/comm_status.dart';

class ChatUserInput extends StatefulWidget {
  final void Function() sender;
  final String? name;
  final CommStatus status;
  final FocusNode focusNode;
  final TextEditingController textEditingController;

  const ChatUserInput({
    super.key,
    required this.sender,
    required this.name,
    required this.status,
    required this.focusNode,
    required this.textEditingController,
  });

  @override
  State<ChatUserInput> createState() => _ChatUserInputState();
}

class _ChatUserInputState extends State<ChatUserInput> {
  @override
  Widget build(BuildContext context) {
    final serverName = widget.name ?? AppLocalizations.of(context)!.unknown;
    String hint = hintText(context, serverName, widget.status);

    return Container(
      color: Colors.grey.withAlpha(32),
      child: Row(
        children: <Widget>[
          Flexible(
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(fontSize: 15.0),
                  enabled: widget.status == CommStatus.connected,
                  textInputAction: TextInputAction.go,
                  controller: widget.textEditingController,
                  focusNode: widget.focusNode,
                  decoration: InputDecoration.collapsed(
                    hintText: hint,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) => setState(() {}),
                  onSubmitted: (value) => widget.sender(),
                ),
              ),
              trailing: Visibility(
                visible: widget.textEditingController.text.isNotEmpty,
                child: IconButton(
                  icon: const Icon(Icons.send, color: MyColors.primary),
                  onPressed: widget.sender,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
