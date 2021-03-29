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
      'profileURL': profileURL ??
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVe0cFaZ9e5Hm9X-tdWRLSvoZqg2bjemBABA&usqp=CAU',
      'createdAt': createdAt ?? '',
      'updatedAt': updatedAt ?? '',
      'seviye': seviye ?? 1,
    };
  }
}
