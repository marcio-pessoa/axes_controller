import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xc/cubit/chat_cubit.dart';

class ChatMessages extends StatefulWidget {
  final ScrollController scrollController;

  const ChatMessages({super.key, required this.scrollController});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    final chat = context.read<ChatCubit>();

    return Flexible(
      child: ListView(
        padding: const EdgeInsets.all(12.0),
        controller: widget.scrollController,
        children: chat.state.messages.map((message) {
          return Row(
            mainAxisAlignment: message.whom == 0
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 4000),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.only(
                        bottom: 8.0, left: 8.0, right: 8.0),
                    // width: 222.0,
                    decoration: BoxDecoration(
                        color:
                            message.whom == 0 ? Colors.blueAccent : Colors.grey,
                        borderRadius: BorderRadius.circular(7.0)),
                    child: Text(
                        (text) {
                          return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                        }(message.text.trim()),
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
