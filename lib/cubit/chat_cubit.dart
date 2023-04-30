import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xc/cubit/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState(messages: []));

  void set({messages}) {
    messages = messages ?? state.messages;

    final update = ChatState(
      messages: messages,
    );

    emit(update);
  }
}
