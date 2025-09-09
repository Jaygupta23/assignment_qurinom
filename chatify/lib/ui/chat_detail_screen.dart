import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/chat_detail/chat_detail_bloc.dart';
import '../blocs/chat_detail/chat_detail_event.dart';
import '../blocs/chat_detail/chat_detail_state.dart';
import '../repositories/chat_repository.dart';
import '../data_providers/socket_provider.dart';
import '../utils/secure_storage.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String chatTitle;
  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.chatTitle,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  late final ChatDetailBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = ChatDetailBloc(
      context.read<ChatRepository>(),
      SocketProvider(),
      widget.chatId,
    )..add(LoadMessages(widget.chatId));
  }

  @override
  void dispose() {
    _bloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SecureStorage.getToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return BlocProvider.value(
          value: _bloc,
          child: Scaffold(
            appBar: AppBar(title: Text(widget.chatTitle)),
            body: Column(
              children: [
                Expanded(
                  child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
                    builder: (context, state) {
                      if (state is ChatDetailLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatDetailLoaded) {
                        final messages = state.messages;
                        return ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (ctx, i) {
                            final msg = messages[messages.length - 1 - i];
                            final isMine = msg["senderId"] == widget.currentUserId;

                            final sentAt = DateTime.tryParse(msg["sentAt"] ?? "");
                            final formattedTime = sentAt != null
                                ? DateFormat('hh:mm a').format(sentAt)
                                : "";

                            return Align(
                              alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isMine ? Colors.blue[200] : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: isMine
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(msg["content"] ?? "", style: const TextStyle(fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(formattedTime,
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is ChatDetailError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(hintText: "Type a message"),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          final content = _controller.text.trim();
                          if (content.isNotEmpty) {
                            _bloc.add(SendMessageRequested(widget.chatId, content));
                            _controller.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

