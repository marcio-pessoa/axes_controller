import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xc/cubit/chat_state.dart';
import 'package:xc/static/comm_message.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState(messages: []));

  void add(Message message) {
    state.messages.add(message);

    final update = ChatState(
      messages: state.messages,
    );

    emit(update);
  }

  void clear() {
    final update = ChatState(
      messages: [],
    );

    emit(update);
  }
}
