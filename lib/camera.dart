import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health/chatbot.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  SharedPreferences prefs;
  String photoUrl = "";

  File avatarImageFile;

  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getImage();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        avatarImageFile = image;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = Random().nextInt(100000).toString();
    StorageReference reference =
        FirebaseStorage.instance.ref().child('$fileName.jpg');
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          setState(() {
            photoUrl = downloadUrl;
            loading = false;
          });
          Firestore.instance.collection('users').document('user').updateData({
            'photoURL': photoUrl,
          }).then((data) async {
            await prefs.setString('photoUrl', photoUrl);
            setState(() {
              loading = false;
            });
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            //   return DialogFlow();
            // }));
          }).catchError((err) {});
        }, onError: (err) {
          print(err);
        });
      } else {}
    }, onError: (err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 243, 240),
      body: Center(
        child: loading ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20,),
            Text("Uploading Photo"),
          ],
        ) : Container(),
      ),
    );
  }
}
