import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/chat.dart';
import '../../utils/secure_storage.dart';
import '../../repositories/chat_repository.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';   // ✅ correct import

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository repo;

  ChatListBloc(this.repo) : super(ChatListInitial()) {
    on<LoadChats>((event, emit) async {
      emit(ChatListLoading());
      try {
        final token = await SecureStorage.getToken() ?? "";
        final chats = (await repo.getUserChats(event.userId, token)).cast<Chat>();
        emit(ChatListLoaded(chats));
      } catch (e) {
        emit(ChatListError(e.toString()));
      }
    });
  }
}
