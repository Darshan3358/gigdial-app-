import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class ChatListScreen extends StatefulWidget {
  final bool isWorker;
  const ChatListScreen({super.key, this.isWorker = false});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final BookingState _bookingState;

  @override
  void initState() {
    super.initState();
    _bookingState = BookingState();
    _bookingState.addListener(_onStateChange);
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bookingState.removeListener(_onStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine whether worker is viewing or customer is viewing
    final bool isWorkerRole = widget.isWorker || 
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)?['isWorker'] == true;

    final Color themeColor = isWorkerRole ? Colors.teal : AppTheme.primaryBlue;
    final String currentUser = _bookingState.getCurrentUserName();

    final state = _bookingState;
    // Filter active chat sessions
    final sessions = state.chatSessions.where((session) {
      if (isWorkerRole) {
        return session.workerName == currentUser;
      } else {
        return session.customerName == currentUser;
      }
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: sessions.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'No chats yet',
                      style: TextStyle(color: Colors.grey[500], fontSize: 15),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: sessions.length,
                padding: const EdgeInsets.symmetric(vertical: 12),
                separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  final String displayName = isWorkerRole ? session.customerName : session.workerName;
                  final lastMessage = session.messages.isNotEmpty ? session.messages.last : null;
                  
                  // Mock avatars based on name
                  String avatarAsset = 'assets/images/worker_ramesh.png';
                  if (displayName == 'Mahesh Patel') {
                    avatarAsset = 'assets/images/worker_mahesh.png';
                  } else if (displayName == 'Jitendra Singh') {
                    // customer avatar
                    avatarAsset = 'assets/images/worker_mahesh.png';
                  }

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage(avatarAsset),
                      backgroundColor: Colors.grey[100],
                    ),
                    title: Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppTheme.textDark,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        lastMessage?.text ?? 'No messages yet',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: lastMessage != null ? AppTheme.textLight : Colors.grey[400],
                        ),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (lastMessage != null)
                          Text(
                            _formatTime(lastMessage.timestamp),
                            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                          ),
                        const SizedBox(height: 6),
                        if (index == 0) // Mock 1 unread message on the first item for UI fidelity
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: themeColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/chat_room',
                        arguments: {
                          'customerName': session.customerName,
                          'workerName': session.workerName,
                          'isWorker': isWorkerRole,
                        },
                      ).then((_) {
                        // Refresh state when coming back
                        setState(() {});
                      });
                    },
                  );
                },
              ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final min = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $ampm';
  }
}
