import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/chat_list/chat_list_bloc.dart';
import '../blocs/chat_list/chat_list_event.dart';
import '../blocs/chat_list/chat_list_state.dart';
import '../repositories/chat_repository.dart';
import 'chat_detail_screen.dart';
import 'login_screen.dart';

class ChatListScreen extends StatelessWidget {
  final String userId;
  const ChatListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatListBloc(ChatRepository())..add(LoadChats(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
                Navigator.pushAndRemoveUntil(
                    context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ChatListBloc, ChatListState>(
          builder: (context, state) {
            if (state is ChatListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatListLoaded) {
              if (state.chats.isEmpty) {
                return const Center(child: Text("No chats found"));
              }
              return ListView.builder(
                itemCount: state.chats.length,
                itemBuilder: (ctx, i) {
                  final chat = state.chats[i];
                  final other = chat.participants.firstWhere(
                    (p) => p['_id'] != userId,
                    orElse: () => null,
                  );
                  final title = other != null ? other['name'] : "Unknown";
                  return ListTile(
                    title: Text(title ?? ""),
                    subtitle: Text(chat.lastMessage?['content'] ?? ""),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailScreen(
                            chatId: chat.id,
                            currentUserId: userId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is ChatListError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
