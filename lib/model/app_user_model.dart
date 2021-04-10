import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppUser {
  final String userID;
  String email;
  String userName;
  String profileURL;
  DateTime createdAt;
  DateTime updatedAt;
  int seviye;

  AppUser({@required this.userID, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID ?? '',
      'email': email ?? '',
      'userName': email != null
          ? email.substring(0, email.indexOf('@')) + _randomSayiUret()
          : '',
      'profileURL': profileURL ??
          'https://w7.pngwing.com/pngs/116/612/png-transparent-joker-batman-two-face-art-joker-face-heroes-head.png',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
    };
  }

  AppUser.IdveResim({@required this.userID, @required this.profileURL});

  AppUser.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profileURL = map['profileURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        seviye = map['seviye'];

  @override
  String toString() {
    return 'AppUser{userID: $userID, email: $email, userName: $userName, profileURL: $profileURL, createdAt: $createdAt, updatedAt: $updatedAt, seviye: $seviye}';
  }

  String _randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
}
