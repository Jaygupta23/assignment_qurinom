import 'package:equatable/equatable.dart';

abstract class ChatDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatDetailLoading extends ChatDetailState {}

class ChatDetailLoaded extends ChatDetailState {
  final List<dynamic> messages;
  ChatDetailLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatDetailError extends ChatDetailState {
  final String message;
  ChatDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatDetailMessageSending extends ChatDetailState {}

class ChatDetailMessageSent extends ChatDetailState {
  final dynamic message;
  ChatDetailMessageSent(this.message);

  @override
  List<Object?> get props => [message];
}