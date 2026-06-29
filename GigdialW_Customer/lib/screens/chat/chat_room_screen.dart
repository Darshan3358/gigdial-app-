import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/booking_state.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late BookingState _bookingState;

  @override
  void initState() {
    super.initState();
    _bookingState = BookingState();
    _bookingState.addListener(_rebuild);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _markMessagesAsRead();
  }

  void _markMessagesAsRead() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      final String customerName = args['customerName'];
      final String workerName = args['workerName'];
      final bool isWorkerRole = args['isWorker'];
      final String partnerName = isWorkerRole ? customerName : workerName;
      _bookingState.markChatMessagesAsRead(partnerName);
    }
  }

  void _rebuild() {
    if (mounted) {
      setState(() {});
      _markMessagesAsRead();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  void dispose() {
    _bookingState.removeListener(_rebuild);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String customerName, String workerName, bool isWorkerRole) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    
    // Add to global state
    _bookingState.addChatMessage(
      customerName, 
      workerName, 
      isWorkerRole ? 'worker' : 'customer', 
      text
    );
    
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String customerName = args['customerName'];
    final String workerName = args['workerName'];
    final bool isWorkerRole = args['isWorker'];

    final Color themeColor = isWorkerRole ? Colors.teal : AppTheme.primaryBlue;
    final String partnerName = isWorkerRole ? customerName : workerName;

    // Get current chat session
    final session = _bookingState.getChatSession(customerName, workerName);

    // Dynamic partner details
    String avatarAsset = 'assets/images/worker_ramesh.png';
    String partnerSubtitle = isWorkerRole ? 'Customer' : 'Active Now';
    if (isWorkerRole) {
      // Partner is customer
      final userMap = _bookingState.usersList.firstWhere(
        (u) => u['name'] == partnerName,
        orElse: () => <String, dynamic>{}
      );
      if (userMap['image'] != null && userMap['image'].toString().isNotEmpty) {
        avatarAsset = userMap['image'];
      } else {
        avatarAsset = 'assets/images/worker_mahesh.png'; // default customer avatar
      }
    } else {
      // Partner is worker
      final w = _bookingState.allWorkersList.firstWhere(
        (w) => w.name == partnerName,
        orElse: () => WorkerModel(id: '', name: '', profession: '', experience: '', rating: 5.0, reviews: '', location: '', image: '', skills: [], about: '')
      );
      if (w.image.isNotEmpty) {
        avatarAsset = w.image;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // light layout background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(avatarAsset),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partnerName,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  partnerSubtitle,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone, color: themeColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling $partnerName...')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat messages log list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: session.messages.length,
                itemBuilder: (context, index) {
                  final message = session.messages[index];
                  final bool isMe = (isWorkerRole && message.sender == 'worker') ||
                      (!isWorkerRole && message.sender == 'customer');

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 2, top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? themeColor : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 2),
                              bottomRight: Radius.circular(isMe ? 2 : 16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: isMe ? Colors.white : AppTheme.textDark,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            _formatTime(message.timestamp),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Bottom text editor panel
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.grey[500]),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      onSubmitted: (_) => _sendMessage(customerName, workerName, isWorkerRole),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(customerName, workerName, isWorkerRole),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
