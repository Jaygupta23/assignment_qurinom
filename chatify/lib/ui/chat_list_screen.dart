import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/chat_detail/chat_detail_bloc.dart';
import '../blocs/chat_detail/chat_detail_event.dart';
import '../blocs/chat_list/chat_list_bloc.dart';
import '../blocs/chat_list/chat_list_event.dart';
import '../blocs/chat_list/chat_list_state.dart';
import '../data_providers/socket_provider.dart';
import '../repositories/chat_repository.dart';
import 'chat_detail_screen.dart';
import 'login_screen.dart';

class ChatListScreen extends StatelessWidget {
  final String userId;
  const ChatListScreen({super.key, required this.userId});

  String _formatTime(String? createdAt) {
    if (createdAt == null) return "";
    try {
      final dateTime = DateTime.parse(createdAt).toLocal(); // convert to local time
      return DateFormat('hh:mm a').format(dateTime); // Example: 10:35 AM
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatListBloc(ChatRepository())..add(LoadChats(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chatify"),
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
              return ListView.separated(
                itemCount: state.chats.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final chat = state.chats[i];
                  final other = chat.participants.firstWhere(
                        (p) => p['_id'] != userId,
                    orElse: () => null,
                  );

                  final title = other != null ? other['name'] : "Unknown";
                  final lastMessage = chat.lastMessage?['content'] ?? "";
                  final initials =
                  (title != null && title.isNotEmpty) ? title[0].toUpperCase() : "?";
                  final createdAt = chat.lastMessage?['createdAt'];
                  final time = _formatTime(createdAt);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        initials,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      title ?? "Unknown",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            final other = chat.participants.firstWhere(
                                  (p) => p['_id'] != userId,
                              orElse: () => {'name': 'Unknown'},
                            );
                            final participantName = other['name'] ?? "Chat";

                            return BlocProvider(
                              create: (context) => ChatDetailBloc(
                                context.read<ChatRepository>(), // repo
                                SocketProvider(),               // socketProvider
                                chat.id,                        // chatId
                              )..add(LoadMessages(chat.id)),   // load messages immediately
                              child: ChatDetailScreen(
                                chatId: chat.id,
                                currentUserId: userId,
                                chatTitle: participantName, // dynamic participant name
                              ),
                            );
                          },
                        ),
                      ).then((_) {
                        // Refresh the chat list when returning
                        context.read<ChatListBloc>().add(LoadChats(userId));
                      });

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
