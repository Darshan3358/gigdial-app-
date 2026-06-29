import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'app_config.dart';

class WorkerModel {
  final String id;
  final String name;
  final String profession;
  final String experience;
  final double rating;
  final String reviews;
  final String location;
  final String image;
  final List<String> skills;
  final String about;
  final String? email;
  final String? phone;
  final String? city;

  WorkerModel({
    this.id = '',
    required this.name,
    required this.profession,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.location,
    required this.image,
    required this.skills,
    required this.about,
    this.email,
    this.phone,
    this.city,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'profession': profession,
    'experience': experience,
    'rating': rating,
    'reviews': reviews,
    'location': location,
    'image': image,
    'skills': skills,
    'about': about,
    'email': email ?? '',
    'phone': phone ?? '',
    'city': city ?? '',
  };

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    var rawSkills = json['skills'];
    List<String> parsedSkills = [];
    if (rawSkills is List) {
      parsedSkills = rawSkills.map((s) => s.toString()).toList();
    } else if (rawSkills is String) {
      parsedSkills = rawSkills.split(',').map((s) => s.trim()).toList();
    }
    return WorkerModel(
      id: json['id'] ?? json['uid'] ?? '',
      name: json['name'] ?? '',
      profession: json['profession'] ?? '',
      experience: json['experience'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviews: json['reviews'] ?? '0 Reviews',
      location: json['location'] ?? '',
      image: json['image'] ?? 'assets/images/worker_ramesh.png',
      skills: parsedSkills,
      about: json['about'] ?? '',
      email: json['email'],
      phone: json['phone'],
      city: json['city'],
    );
  }
}

class BookingModel {
  final String id;
  final String title;
  final String location;
  final String dateTime;
  String status; // 'Pending', 'Accepted', 'On the Way', 'In Progress', 'Completed', 'Cancelled'
  final String workerName;
  final String customerName;
  final String serviceName;
  final String description;
  final double price;

  BookingModel({
    this.id = '',
    required this.title,
    required this.location,
    required this.dateTime,
    required this.status,
    required this.workerName,
    this.customerName = 'Jitendra Singh',
    required this.serviceName,
    required this.description,
    this.price = 299.0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'location': location,
    'dateTime': dateTime,
    'status': status.toLowerCase().replaceAll(' ', '_'),
    'workerName': workerName,
    'customerName': customerName,
    'serviceName': serviceName,
    'description': description,
    'price': price,
  };

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status'] ?? 'pending';
    String mappedStatus = 'Pending';
    if (rawStatus == 'accepted') {
      mappedStatus = 'Accepted';
    } else if (rawStatus == 'on_the_way') {
      mappedStatus = 'On the Way';
    } else if (rawStatus == 'in_progress') {
      mappedStatus = 'In Progress';
    } else if (rawStatus == 'completed') {
      mappedStatus = 'Completed';
    } else if (rawStatus == 'cancelled') {
      mappedStatus = 'Cancelled';
    }
    
    return BookingModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      dateTime: json['dateTime'] ?? '',
      status: mappedStatus,
      workerName: json['workerName'] ?? '',
      customerName: json['customerName'] ?? 'Jitendra Singh',
      serviceName: json['serviceName'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 299.0,
    );
  }
}

class ChatMessage {
  final String senderId;
  final String senderRole;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.senderRole,
    required this.message,
    required this.timestamp,
  });

  String get sender => senderRole;
  String get text => message;

  Map<String, dynamic> toJson() => {
    'senderId': senderId,
    'senderRole': senderRole,
    'message': message,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    DateTime parsedTime = DateTime.now();
    if (json['timestamp'] != null) {
      if (json['timestamp'] is int) {
        parsedTime = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);
      } else if (json['timestamp'] is String) {
        parsedTime = DateTime.tryParse(json['timestamp']) ?? DateTime.now();
      }
    }
    return ChatMessage(
      senderId: json['senderId'] ?? '',
      senderRole: json['senderRole'] ?? json['sender'] ?? 'customer',
      message: json['message'] ?? json['text'] ?? '',
      timestamp: parsedTime,
    );
  }
}

class ChatSession {
  final String bookingId;
  final String customerName;
  final String workerName;
  final List<ChatMessage> messages;

  ChatSession({
    required this.bookingId,
    required this.customerName,
    required this.workerName,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
    'bookingId': bookingId,
    'customerName': customerName,
    'workerName': workerName,
    'messages': messages.map((m) => m.toJson()).toList(),
  };

  factory ChatSession.fromJson(String bookingId, Map<String, dynamic> json, {String? customerName, String? workerName}) {
    List<ChatMessage> list = [];
    final messagesData = json['messages'] ?? json;
    
    if (messagesData is Map) {
      messagesData.forEach((k, v) {
        if (v is Map) {
          list.add(ChatMessage.fromJson(Map<String, dynamic>.from(v)));
        }
      });
      list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } else if (messagesData is List) {
      list = messagesData
          .where((m) => m != null)
          .map((m) => ChatMessage.fromJson(Map<String, dynamic>.from(m)))
          .toList();
    }
    
    return ChatSession(
      bookingId: bookingId,
      customerName: json['customerName'] ?? customerName ?? 'Customer',
      workerName: json['workerName'] ?? workerName ?? 'Worker',
      messages: list,
    );
  }
}

class BookingState extends ChangeNotifier {
  static final BookingState _instance = BookingState._internal();
  factory BookingState() => _instance;

  BookingState._internal() {
    _initWorkers();
    _startFirebaseSync();
    setupAuthListeners();
  }

  final Map<String, List<WorkerModel>> workersByCategory = {};
  final List<BookingModel> bookings = [];
  final List<ChatSession> chatSessions = [];
  final List<Map<String, dynamic>> usersList = [];
  final List<WorkerModel> allWorkersList = [];
  final List<Map<String, dynamic>> notifications = [];
  final List<Map<String, dynamic>> paymentsList = [];

  StreamSubscription<DatabaseEvent>? _notificationsSub;
  StreamSubscription<DatabaseEvent>? _subscriptionsSub;

  String activePlan = 'No Active Plan';
  int subscriptionDaysLeft = 0;
  bool isSubscriptionActive = false;

  void _initWorkers() {
    workersByCategory['Electrician'] = [
      WorkerModel(
        id: 'worker_ramesh',
        name: 'Ramesh Yadav',
        profession: 'Electrician',
        experience: '8 Years Experience',
        rating: 4.8,
        reviews: '120 Reviews',
        location: 'Naroda, Ahmedabad',
        image: 'assets/images/worker_ramesh.png',
        skills: ['House Wiring', 'Fan Repair', 'Light Installation', 'Switch Board', 'MCB Repair', 'Short Circuit'],
        about: 'I am a professional electrician with 8 years of experience in all type of electrical work.',
      ),
      WorkerModel(
        id: 'worker_mahesh',
        name: 'Mahesh Patel',
        profession: 'Electrician',
        experience: '5 Years Experience',
        rating: 4.7,
        reviews: '95 Reviews',
        location: 'Nikol, Ahmedabad',
        image: 'assets/images/worker_mahesh.png',
        skills: ['Appliance Repair', 'Switch Board', 'Inverter Setup', 'AC Fitting'],
        about: 'Dedicated electrician with 5 years experience.',
      ),
    ];
    workersByCategory['Plumber'] = [
      WorkerModel(
        id: 'worker_suresh_plumber',
        name: 'Suresh Patel',
        profession: 'Plumber',
        experience: '7 Years Experience',
        rating: 4.7,
        reviews: '110 Reviews',
        location: 'Nikol, Ahmedabad',
        image: 'assets/images/worker_mahesh.png',
        skills: ['Pipe Leakage', 'Tap Repair', 'Drain Cleaning', 'Basin Setup'],
        about: 'Experienced plumber specializing in fixing internal blockages.',
      ),
    ];
  }

  void setupAuthListeners() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _notificationsSub?.cancel();
      _subscriptionsSub?.cancel();
      
      if (user != null) {
        _notificationsSub = FirebaseDatabase.instance.ref('notifications/${user.uid}').onValue.listen((event) {
          notifications.clear();
          final data = event.snapshot.value;
          if (data is Map) {
            data.forEach((key, val) {
              if (val is Map) {
                final map = Map<String, dynamic>.from(val);
                map['key'] = key;
                notifications.add(map);
              }
            });
            notifications.sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));
          }
          notifyListeners();
        });

        _subscriptionsSub = FirebaseDatabase.instance.ref('subscriptions/${user.uid}').onValue.listen((event) {
          final data = event.snapshot.value;
          if (data is Map) {
            final subData = Map<String, dynamic>.from(data);
            activePlan = subData['plan'] ?? 'Professional Plan';
            final endDateMs = subData['endDate'] ?? 0;
            final nowMs = DateTime.now().millisecondsSinceEpoch;
            subscriptionDaysLeft = endDateMs > nowMs 
                ? ((endDateMs - nowMs) / (1000 * 60 * 60 * 24)).ceil() 
                : 0;
            isSubscriptionActive = subData['status'] == 'active' && subscriptionDaysLeft > 0;
          } else {
            activePlan = 'No Active Plan';
            subscriptionDaysLeft = 0;
            isSubscriptionActive = false;
          }
          notifyListeners();
        });
      }
    });
  }

  void _startFirebaseSync() {
    FirebaseDatabase.instance.ref('bookings').onValue.listen((event) {
      bookings.clear();
      final data = event.snapshot.value;
      if (data is Map) {
        data.forEach((key, val) {
          if (val is Map) {
            final map = Map<String, dynamic>.from(val);
            if (map['id'] == null || map['id'].toString().isEmpty) {
              map['id'] = key;
            }
            bookings.add(BookingModel.fromJson(map));
          }
        });
        bookings.sort((a, b) => b.id.compareTo(a.id));
      }
      notifyListeners();
    });

    FirebaseDatabase.instance.ref('users').onValue.listen((event) {
      usersList.clear();
      final data = event.snapshot.value;
      if (data is Map) {
        data.forEach((key, val) {
          if (val is Map) {
            final map = Map<String, dynamic>.from(val);
            if (map['uid'] == null) map['uid'] = key;
            usersList.add(map);
          }
        });
      }
      notifyListeners();
    });

    FirebaseDatabase.instance.ref('workers').onValue.listen((event) {
      allWorkersList.clear();
      final data = event.snapshot.value;
      if (data is Map) {
        workersByCategory.clear();
        data.forEach((key, val) {
          if (val is Map) {
            final map = Map<String, dynamic>.from(val);
            if (map['id'] == null) map['id'] = key;
            final worker = WorkerModel.fromJson(map);
            allWorkersList.add(worker);
            
            final category = worker.profession;
            if (!workersByCategory.containsKey(category)) {
              workersByCategory[category] = [];
            }
            workersByCategory[category]!.add(worker);
          }
        });
      } else {
        _seedWorkersToDatabase();
      }
      notifyListeners();
    });

    FirebaseDatabase.instance.ref('chats').onValue.listen((event) {
      chatSessions.clear();
      final data = event.snapshot.value;
      if (data is Map) {
        data.forEach((bookingIdStr, messagesData) {
          if (messagesData is Map) {
            final map = Map<String, dynamic>.from(messagesData);
            
            String customerName = 'Jitendra Singh';
            String workerName = 'Ramesh Yadav';
            
            final b = bookings.firstWhere(
              (element) => element.id == bookingIdStr,
              orElse: () => BookingModel(id: '', title: '', location: '', dateTime: '', status: '', workerName: '', serviceName: '', description: '')
            );
            if (b.id.isNotEmpty) {
              workerName = b.workerName;
              customerName = b.customerName;
            } else if (bookingIdStr.startsWith('chat_')) {
              // Parse customerName and workerName from chat_CustomerName_WorkerName
              final cleanId = bookingIdStr.substring(5); // remove 'chat_'
              bool parsed = false;
              for (var w in allWorkersList) {
                final wKey = w.name.toLowerCase().replaceAll(' ', '_');
                if (cleanId.toLowerCase().endsWith('_$wKey')) {
                  workerName = w.name;
                  final custPartEnd = cleanId.length - wKey.length - 1;
                  if (custPartEnd > 0) {
                    final custPart = cleanId.substring(0, custPartEnd);
                    customerName = custPart.replaceAll('_', ' ');
                    parsed = true;
                    break;
                  }
                }
              }
              if (!parsed) {
                final parts = cleanId.split('_');
                if (parts.length >= 2) {
                  workerName = parts.last;
                  customerName = parts.sublist(0, parts.length - 1).join(' ');
                }
              }
            }
            
            final session = ChatSession.fromJson(bookingIdStr, map, customerName: customerName, workerName: workerName);
            chatSessions.add(session);
          }
        });
      }
      notifyListeners();
    });

    // Sync ratings and update average score dynamically
    FirebaseDatabase.instance.ref('ratings').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        final Map<String, List<double>> workerRatings = {};
        data.forEach((bookingId, val) {
          if (val is Map) {
            final ratingData = Map<String, dynamic>.from(val);
            final workerId = ratingData['workerId'];
            final r = (ratingData['rating'] as num?)?.toDouble() ?? 5.0;
            if (workerId != null) {
              workerRatings.putIfAbsent(workerId, () => []).add(r);
            }
          }
        });

        for (var i = 0; i < allWorkersList.length; i++) {
          final w = allWorkersList[i];
          if (workerRatings.containsKey(w.id)) {
            final list = workerRatings[w.id]!;
            final avg = list.reduce((a, b) => a + b) / list.length;
            allWorkersList[i] = WorkerModel(
              id: w.id,
              name: w.name,
              profession: w.profession,
              experience: w.experience,
              rating: double.parse(avg.toStringAsFixed(1)),
              reviews: '${list.length} Reviews',
              location: w.location,
              image: w.image,
              skills: w.skills,
              about: w.about,
              email: w.email,
              phone: w.phone,
              city: w.city,
            );
          }
        }
      }
      notifyListeners();
    });

    FirebaseDatabase.instance.ref('payments').onValue.listen((event) {
      paymentsList.clear();
      final data = event.snapshot.value;
      if (data is Map) {
        data.forEach((key, val) {
          if (val is Map) {
            final map = Map<String, dynamic>.from(val);
            if (map['id'] == null) map['id'] = key;
            paymentsList.add(map);
          }
        });
        paymentsList.sort((a, b) => (b['createdAt'] ?? 0).compareTo(a['createdAt'] ?? 0));
      }
      notifyListeners();
    });
  }

  Future<void> _seedWorkersToDatabase() async {
    final ref = FirebaseDatabase.instance.ref('workers');
    final List<WorkerModel> list = [];
    workersByCategory.forEach((category, workers) {
      list.addAll(workers);
    });
    for (var w in list) {
      await ref.child(w.id).set(w.toJson());
    }
  }

  List<WorkerModel> getWorkersForService(String service) {
    return workersByCategory[service] ?? workersByCategory['Electrician']!;
  }

  String getCurrentUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Jitendra Singh';
    final uid = user.uid;
    if (AppConfig.flavor == AppFlavor.worker) {
      final worker = allWorkersList.firstWhere(
        (w) => w.id == uid,
        orElse: () => WorkerModel(id: '', name: '', profession: '', experience: '', rating: 5.0, reviews: '', location: '', image: '', skills: [], about: '')
      );
      if (worker.name.isNotEmpty) return worker.name;
    } else {
      final uMap = usersList.firstWhere(
        (u) => u['uid'] == uid,
        orElse: () => <String, dynamic>{}
      );
      if (uMap['name'] != null) return uMap['name'];
    }
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    return AppConfig.flavor == AppFlavor.worker ? 'Ramesh Yadav' : 'Jitendra Singh';
  }

  WorkerModel? getCurrentWorkerProfile() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    try {
      return allWorkersList.firstWhere((w) => w.id == uid);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? getCurrentUserProfile() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    try {
      return usersList.firstWhere((u) => u['uid'] == uid);
    } catch (_) {
      return null;
    }
  }

  Future<void> sendNotification(String uid, String title, String message) async {
    try {
      final ref = FirebaseDatabase.instance.ref('notifications/$uid').push();
      await ref.set({
        'id': ref.key,
        'title': title,
        'message': message,
        'read': false,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> addBooking(BookingModel booking) async {
    try {
      final ref = FirebaseDatabase.instance.ref('bookings').push();
      final newBooking = BookingModel(
        id: ref.key ?? '',
        title: booking.title,
        location: booking.location,
        dateTime: booking.dateTime,
        status: booking.status,
        workerName: booking.workerName,
        customerName: booking.customerName.isNotEmpty && booking.customerName != 'Jitendra Singh'
            ? booking.customerName 
            : getCurrentUserName(),
        serviceName: booking.serviceName,
        description: booking.description,
        price: booking.price,
      );
      await ref.set(newBooking.toJson());

      final worker = allWorkersList.firstWhere(
        (w) => w.name == booking.workerName,
        orElse: () => WorkerModel(id: '', name: '', profession: '', experience: '', rating: 5.0, reviews: '', location: '', image: '', skills: [], about: '')
      );
      if (worker.id.isNotEmpty) {
        await sendNotification(worker.id, 'New Booking Alert', 'You have a new request for ${booking.title}');
      }
    } catch (e) {
      print('Error adding booking: $e');
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      final b = bookings.firstWhere(
        (element) => element.id == bookingId,
        orElse: () => BookingModel(id: '', title: '', location: '', dateTime: '', status: '', workerName: '', serviceName: '', description: '')
      );
      if (b.id.isNotEmpty) {
        final dbStatus = status.toLowerCase().replaceAll(' ', '_');
        await FirebaseDatabase.instance.ref('bookings/${b.id}/status').set(dbStatus);

        final customer = usersList.firstWhere(
          (u) => u['name'] == b.customerName,
          orElse: () => <String, dynamic>{}
        );
        final worker = allWorkersList.firstWhere(
          (w) => w.name == b.workerName,
          orElse: () => WorkerModel(id: '', name: '', profession: '', experience: '', rating: 5.0, reviews: '', location: '', image: '', skills: [], about: '')
        );

        if (customer['uid'] != null) {
          await sendNotification(customer['uid'], 'Booking Update', 'Your booking "${b.title}" is now: $status');
        }
        if (worker.id.isNotEmpty) {
          await sendNotification(worker.id, 'Booking Update', 'Booking "${b.title}" status updated to: $status');
        }
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> buySubscription(String planName, int days, {double? amount, String? paymentMethod}) async {
    activePlan = planName;
    subscriptionDaysLeft = days;
    isSubscriptionActive = true;
    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final now = DateTime.now();
        await FirebaseDatabase.instance.ref('subscriptions/$uid').set({
          'plan': planName,
          'startDate': now.millisecondsSinceEpoch,
          'endDate': now.add(Duration(days: days)).millisecondsSinceEpoch,
          'status': 'active',
        });

        // Add payment record
        final double finalAmount = amount ?? (planName.contains('Premium') ? 999.0 : (planName.contains('Professional') ? 599.0 : 199.0));
        final String finalMethod = paymentMethod ?? 'UPI';
        final paymentRef = FirebaseDatabase.instance.ref('payments').push();
        await paymentRef.set({
          'id': paymentRef.key ?? '',
          'workerUid': uid,
          'plan': planName,
          'amount': finalAmount,
          'method': finalMethod,
          'status': 'success',
          'createdAt': now.millisecondsSinceEpoch,
        });
      } catch (e) {
        print('Error updating subscription: $e');
      }
    }
  }

  ChatSession getChatSession(String customer, String worker) {
    final b = bookings.firstWhere(
      (element) => element.workerName == worker && (element.status == 'Pending' || element.status == 'Accepted' || element.status == 'On the Way' || element.status == 'In Progress'),
      orElse: () => BookingModel(id: '', title: '', location: '', dateTime: '', status: '', workerName: '', serviceName: '', description: '')
    );
    final bookingId = b.id.isNotEmpty ? b.id : 'chat_${customer}_${worker}'.replaceAll(' ', '_');
    
    for (var session in chatSessions) {
      if (session.bookingId == bookingId) {
        return session;
      }
    }
    final newSession = ChatSession(
      bookingId: bookingId,
      customerName: customer,
      workerName: worker,
      messages: [],
    );
    chatSessions.add(newSession);
    return newSession;
  }

  Future<void> addChatMessage(String customer, String worker, String sender, String text) async {
    try {
      final b = bookings.firstWhere(
        (element) => element.workerName == worker && (element.status == 'Pending' || element.status == 'Accepted' || element.status == 'On the Way' || element.status == 'In Progress'),
        orElse: () => BookingModel(id: '', title: '', location: '', dateTime: '', status: '', workerName: '', serviceName: '', description: '')
      );
      final bookingId = b.id.isNotEmpty ? b.id : 'chat_${customer}_${worker}'.replaceAll(' ', '_');
      
      // Save customer and worker names at the chat root node
      await FirebaseDatabase.instance.ref('chats/$bookingId').update({
        'customerName': customer,
        'workerName': worker,
      });

      final messageRef = FirebaseDatabase.instance.ref('chats/$bookingId/messages').push();
      
      final newMessage = ChatMessage(
        senderId: FirebaseAuth.instance.currentUser?.uid ?? sender,
        senderRole: sender,
        message: text,
        timestamp: DateTime.now(),
      );
      
      await messageRef.set(newMessage.toJson());

      // Notify the other party
      if (sender == 'customer') {
        final w = allWorkersList.firstWhere(
          (element) => element.name == worker,
          orElse: () => WorkerModel(id: '', name: '', profession: '', experience: '', rating: 5.0, reviews: '', location: '', image: '', skills: [], about: '')
        );
        if (w.id.isNotEmpty) {
          await sendNotification(w.id, 'New Message', 'Message from $customer: $text');
        }
      } else {
        final c = usersList.firstWhere(
          (element) => element['name'] == customer,
          orElse: () => <String, dynamic>{}
        );
        if (c['uid'] != null) {
          await sendNotification(c['uid'], 'New Message', 'Message from $worker: $text');
        }
      }
    } catch (e) {
      print('Error adding chat message: $e');
    }
  }

  Future<void> addRating(String bookingId, String workerId, String customerId, double rating, String review) async {
    try {
      await FirebaseDatabase.instance.ref('ratings/$bookingId').set({
        'workerId': workerId,
        'customerId': customerId,
        'rating': rating,
        'review': review,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print('Error adding rating: $e');
    }
  }

  void addWorkerToCategory(String category, WorkerModel worker) {
    try {
      FirebaseDatabase.instance.ref('workers/${worker.id}').set(worker.toJson());
    } catch (e) {
      print('Error adding worker: $e');
    }
  }

  void addSkillToWorker(String workerName, String skill) {
    final worker = allWorkersList.firstWhere(
      (element) => element.name == workerName,
      orElse: () => WorkerModel(id: '', name: '', profession: '', experience: '', rating: 5.0, reviews: '', location: '', image: '', skills: [], about: '')
    );
    if (worker.id.isNotEmpty) {
      if (!worker.skills.contains(skill)) {
        final newSkills = List<String>.from(worker.skills)..add(skill);
        FirebaseDatabase.instance.ref('workers/${worker.id}/skills').set(newSkills);
      }
    }
  }

  Map<String, dynamic>? get currentUserProfile => getCurrentUserProfile();

  List<Map<String, dynamic>> get allWorkers {
    return allWorkersList.map((w) => {
      'id': w.id,
      'name': w.name,
      'profession': w.profession,
      'rating': w.rating,
      'image': w.image.isNotEmpty ? w.image : 'assets/images/worker_ramesh.png',
      'location': w.location,
    }).toList();
  }

  Future<void> clearCurrentUser() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
    notifyListeners();
  }

  Future<bool> updateUserProfile(String name, String phone, String email, {String? image}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;
    try {
      final role = AppConfig.flavor == AppFlavor.worker ? 'workers' : 'users';
      final Map<String, dynamic> updates = {
        'name': name,
        'phone': phone,
        'email': email,
      };
      if (image != null) {
        updates['image'] = image;
      }
      await FirebaseDatabase.instance.ref('$role/$uid').update(updates);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await FirebaseDatabase.instance.ref('users/$uid').remove();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<void> deleteWorker(String uid) async {
    try {
      await FirebaseDatabase.instance.ref('workers/$uid').remove();
    } catch (e) {
      print('Error deleting worker: $e');
    }
  }

  Future<void> refundPayment(String paymentId) async {
    try {
      await FirebaseDatabase.instance.ref('payments/$paymentId/status').set('refunded');
    } catch (e) {
      print('Error refunding payment: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseDatabase.instance.ref('notifications/$uid/$notificationId/read').set(true);
      } catch (e) {
        print('Error marking notification as read: $e');
      }
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final ref = FirebaseDatabase.instance.ref('notifications/$uid');
        final snapshot = await ref.get();
        if (snapshot.exists && snapshot.value is Map) {
          final data = snapshot.value as Map;
          final Map<String, dynamic> updates = {};
          data.forEach((key, val) {
            updates['$key/read'] = true;
          });
          await ref.update(updates);
        }
      } catch (e) {
        print('Error marking all notifications as read: $e');
      }
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseDatabase.instance.ref('notifications/$uid/$notificationId').remove();
      } catch (e) {
        print('Error deleting notification: $e');
      }
    }
  }

  Future<void> clearAllNotifications() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseDatabase.instance.ref('notifications/$uid').remove();
      } catch (e) {
        print('Error clearing all notifications: $e');
      }
    }
  }

  Future<void> markChatMessagesAsRead(String displayName) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final ref = FirebaseDatabase.instance.ref('notifications/$uid');
        final snapshot = await ref.get();
        if (snapshot.exists && snapshot.value is Map) {
          final data = snapshot.value as Map;
          final Map<String, dynamic> updates = {};
          data.forEach((key, val) {
            if (val is Map) {
              final title = val['title'];
              final message = val['message'] ?? '';
              final read = val['read'] ?? false;
              if (read == false && title == 'New Message' && message.toString().contains(displayName)) {
                updates['$key/read'] = true;
              }
            }
          });
          if (updates.isNotEmpty) {
            await ref.update(updates);
          }
        }
      } catch (e) {
        print('Error marking chat messages as read: $e');
      }
    }
  }
}
