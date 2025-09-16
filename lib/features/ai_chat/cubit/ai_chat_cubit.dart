import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  AiChatCubit() : super(const AiChatState.initial());

  void sendMessage(String text) {
    final updated = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage(role: ChatRole.user, text: text));

    // Mock AI: simple canned response based on keywords
    String reply = 'Let me help you with that. Could you provide more details?';
    final l = text.toLowerCase();
    if (l.contains('budget')) {
      reply =
          'For budgeting, you can set a comfortable range. We will match lawyers within it.';
    } else if (l.contains('criminal')) {
      reply =
          'Criminal cases often start with FIR and bail considerations. I can guide you through steps.';
    } else if (l.contains('divorce') || l.contains('family')) {
      reply =
          'Family matters may include mediation before litigation. I can outline the process.';
    }

    updated.add(ChatMessage(role: ChatRole.assistant, text: reply));
    emit(state.copyWith(messages: updated));
  }
}
