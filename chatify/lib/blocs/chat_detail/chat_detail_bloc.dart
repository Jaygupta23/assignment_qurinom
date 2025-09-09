import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data_providers/socket_provider.dart';
import '../../repositories/chat_repository.dart';
import '../../utils/secure_storage.dart';
import 'chat_detail_event.dart';
import 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final ChatRepository repo;
  final SocketProvider socketProvider;
  final String chatId;

  ChatDetailBloc(this.repo, this.socketProvider, this.chatId)
      : super(ChatDetailLoading()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessageRequested>(_onSendMessageRequested);
    on<IncomingMessageEvent>(_onIncomingMessage);

    _initSocket();
  }

  Future<void> _initSocket() async {
    final userId = await SecureStorage.getUserId() ?? "";
    final token = await SecureStorage.getToken() ?? "";

    socketProvider.connect(userId, token: token);

    socketProvider.on("new_message", (data) {
      if (data["chatId"] == chatId) {
        add(IncomingMessageEvent(data));
      }
    });
  }

  Future<void> _onLoadMessages(
      LoadMessages event, Emitter<ChatDetailState> emit) async {
    try {
      final token = await SecureStorage.getToken() ?? "";
      final msgs = await repo.getMessages(chatId, token);
      emit(ChatDetailLoaded(msgs));
    } catch (e) {
      print("Error loading messages: $e");
      emit(ChatDetailError(e.toString()));
    }
  }

  Future<void> _onSendMessageRequested(
      SendMessageRequested event, Emitter<ChatDetailState> emit) async {
    if (state is ChatDetailLoaded) {
      final token = await SecureStorage.getToken() ?? "";
      final userId = await SecureStorage.getUserId() ?? "";

      final sentMsg = await repo.sendMessage(
        chatId: chatId,
        senderId: userId,
        content: event.content,
        token: token,
      );

      // Optionally emit immediately
      socketProvider.emit("client_sent", sentMsg);

      final updated = List.of((state as ChatDetailLoaded).messages)..add(sentMsg);
      emit(ChatDetailLoaded(updated));
    }
  }

  void _onIncomingMessage(
      IncomingMessageEvent event, Emitter<ChatDetailState> emit) {
    if (state is ChatDetailLoaded) {
      final updated = List.of((state as ChatDetailLoaded).messages)
        ..add(event.message);
      emit(ChatDetailLoaded(updated));
    }
  }

  @override
  Future<void> close() {
    socketProvider.disconnect();
    return super.close();
  }
}
