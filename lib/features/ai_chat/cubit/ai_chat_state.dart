part of 'ai_chat_cubit.dart';

enum ChatRole { user, assistant }

class ChatMessage extends Equatable {
  final ChatRole role;
  final String text;
  const ChatMessage({required this.role, required this.text});

  @override
  List<Object?> get props => [role, text];
}

class AiChatState extends Equatable {
  final List<ChatMessage> messages;
  const AiChatState({required this.messages});

  const AiChatState.initial() : messages = const [];

  AiChatState copyWith({List<ChatMessage>? messages}) =>
      AiChatState(messages: messages ?? this.messages);

  @override
  List<Object?> get props => [messages];
}
