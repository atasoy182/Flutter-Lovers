import 'package:flutter/material.dart';
import 'package:flutter_lovers/model/app_user_model.dart';

class KonusmaPage extends StatefulWidget {
  final AppUser currentUser;
  final AppUser sohbetEdilenUser;

  KonusmaPage({this.currentUser, this.sohbetEdilenUser});

  @override
  _KonusmaPageState createState() => _KonusmaPageState();
}

class _KonusmaPageState extends State<KonusmaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.currentUser.userName),
            Text(widget.sohbetEdilenUser.userName)
          ],
        ),
      ),
    );
  }
}
