import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
}

class LoadChats extends ChatListEvent {
  final String userId;
  const LoadChats(this.userId);

  @override
  List<Object?> get props => [userId];
}
