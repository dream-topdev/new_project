import 'package:cloud_firestore/cloud_firestore.dart';

//للبحث والتمرير الى صفحة chat_screen.dart
class Users {
  Users({
    required this.email,
    required this.username,
    required this.avatar,
    required this.uid,
    required this.full_name,
  });

  late String email;
  late String username;
  late String uid;
  late String avatar;
  late String full_name;

  Users.fromJson(Map<String, dynamic> json) {
    email = json['email'] ?? '';
    username = json['username'] ?? '';
    avatar = json['avatar'] ?? '';
    uid = json['uid'] ?? '';
    full_name = json['full_name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    data['avatar'] = avatar;
    data['uid'] = uid;
    data['full_name'] = full_name;

    return data;
  }
}

//للظهور المرسلين في صفحة messages.dart
class UsersChat {
  UsersChat({
    required this.email,
    required this.name,
    required this.recipient,
    required this.msg,
    required this.time,
    required this.avatar,
  });

  late String email;
  late String name;
  late String recipient;
  late List<String> msg; // تغيير نوع الحقل ليكون قائمة من النصوص
  late Timestamp time;
  late String avatar;

  UsersChat.fromJson(Map<String, dynamic> json) {
    email = json['email'] ?? '';
    name = json['name'] ?? '';
    recipient = json['recipient'] ?? '';
    msg = List<String>.from(json['msg'] ?? []); // استخدام List<String>
    time = json['time'] ??
        Timestamp.now(); // يمكنك تعيين قيمة افتراضية أو استخدام وقت الآن
    avatar = json['avatar'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['recipient'] = recipient;
    data['msg'] = msg; // ترك الحقل كمصفوفة من النصوص
    data['time'] = time;
    data['avatar'] = avatar;

    return data;
  }
}


