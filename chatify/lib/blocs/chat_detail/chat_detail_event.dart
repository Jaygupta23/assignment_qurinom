import 'package:equatable/equatable.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();
}

class LoadMessages extends ChatDetailEvent {
  final String chatId;
  const LoadMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessageRequested extends ChatDetailEvent {
  final String chatId;
  final String content;
  const SendMessageRequested(this.chatId, this.content);

  @override
  List<Object?> get props => [chatId, content];
}

class IncomingMessageEvent extends ChatDetailEvent {
  final dynamic message;
  const IncomingMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}
