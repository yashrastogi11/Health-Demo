import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:math';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences prefs;
  String name = "";
  String age = "1.0";
  String photoUrl = '';

  // double _age = 1.0;

  bool isLoading = false;

  TextEditingController controllerName;
  TextEditingController controllerAge;

  final FocusNode focusNodeName = new FocusNode();
  final FocusNode focusNodeAge = new FocusNode();

  File avatarImageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readLocal();

    // readPhotoUrl();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    age = prefs.getString("age") ?? '1.0';
    // age = _age.toString();
    photoUrl = prefs.getString('photoUrl') ?? '';

    controllerName = new TextEditingController(text: name);
    controllerAge = new TextEditingController(text: age);

    // Force refresh input
    setState(() {});
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
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
          });
          Firestore.instance.collection('users').document('user').updateData({
            'name': name,
            'age': age,
            'photoURL': photoUrl,
          }).then((data) async {
            await prefs.setString('photoUrl', photoUrl);
            setState(() {
              isLoading = false;
            });
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void handleUpdateData() {
    focusNodeName.unfocus();
    focusNodeAge.unfocus();

    setState(() {
      isLoading = true;
    });

    Firestore.instance.collection('users').document("user").updateData({
      'name': name,
      'age': age,
      'photoURL': photoUrl,
    }).then((data) async {
      await prefs.setString('photoUrl', photoUrl);
      await prefs.setString('age', age);
      await prefs.setString('name', name);
      setState(() {
        photoUrl = photoUrl;
        isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 243, 240),
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          "My Profile",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 245, 243, 240),
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Avatar
                Container(
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        (avatarImageFile == null)
                            ? (photoUrl != ''
                                    ? Material(
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Color.fromARGB(
                                                    255, 100, 56, 83),
                                              ),
                                            ),
                                            width: 90.0,
                                            height: 90.0,
                                            padding: EdgeInsets.all(20.0),
                                          ),
                                          imageUrl: photoUrl,
                                          width: 90.0,
                                          height: 90.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(45.0)),
                                        clipBehavior: Clip.hardEdge,
                                      )
                                    : Icon(
                                        Icons.account_circle,
                                        size: 90.0,
                                        color: Colors.grey,
                                      )

                                // StreamBuilder<QuerySnapshot>(
                                //     stream: Firestore.instance
                                //         .collection('users')
                                //         .snapshots(),
                                //     builder: (BuildContext context,
                                //         AsyncSnapshot<QuerySnapshot> snapshot) {
                                //       switch (snapshot.connectionState) {
                                //         case ConnectionState.waiting:
                                //           return new Center(
                                //               child:
                                //                   CircularProgressIndicator());
                                //         default:
                                //           return Container(
                                //             width: 90,
                                //             height: 90,
                                //             child: Image(
                                //               image: NetworkImage(photoUrl ?? "https://firebasestorage.googleapis.com/v0/b/mental-health-app-b024e.appspot.com/o/62489.jpg?alt=media&token=fc56829a-ee82-4738-becc-cec28e01e025"),
                                //             ),
                                //           );
                                //       }
                                //     },
                                //   )
                                )
                            : Material(
                                child: Image.file(
                                  avatarImageFile,
                                  width: 90.0,
                                  height: 90.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          onPressed: getImage,
                          padding: EdgeInsets.all(30.0),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.grey,
                          iconSize: 30.0,
                        ),
                      ],
                    ),
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.all(20.0),
                ),

                // Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Name
                    Container(
                      child: Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 100, 107, 217),
                          fontSize: 18,
                        ),
                      ),
                      margin: EdgeInsets.only(
                        left: 10.0,
                        bottom: 10.0,
                        top: 10.0,
                      ),
                    ),
                    Container(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Color.fromARGB(255, 100, 107, 217),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: name,
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          controller: controllerName,
                          onChanged: (value) {
                            name = value;
                          },
                          focusNode: focusNodeName,
                        ),
                      ),
                      margin: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                    ),

                    // Age
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Age',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 100, 107, 217),
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            alignment: Alignment.center,
                            child: Text(
                              age,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(
                        left: 10.0,
                        top: 30.0,
                        bottom: 10.0,
                      ),
                    ),
                    // Container(
                    //   child: Theme(
                    //     data: Theme.of(context).copyWith(
                    //       primaryColor: Color.fromARGB(255, 130, 200, 58),
                    //     ),
                    //     child: TextField(
                    //       decoration: InputDecoration(
                    //         hintText: age,
                    //         contentPadding: EdgeInsets.all(5.0),
                    //         hintStyle: TextStyle(
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //       controller: controllerAge,
                    //       onChanged: (value) {
                    //         age = value;
                    //       },
                    //       focusNode: focusNodeAge,
                    //     ),
                    //   ),
                    //   margin: EdgeInsets.only(
                    //     left: 20.0,
                    //     right: 20.0,
                    //   ),
                    // ),

                    Slider(
                      value: double.parse(age),
                      min: 1.0,
                      max: 100.0,
                      divisions: 99,
                      activeColor: Color.fromARGB(255, 130, 200, 58),
                      inactiveColor: Colors.grey,
                      label: age,
                      onChanged: (double newValue) {
                        setState(() {
                          age = newValue.toString();
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(
                  height: 40,
                ),

                // Button
                ButtonTheme(
                  child: RaisedButton(
                    onPressed: handleUpdateData,
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    color: Color.fromARGB(255, 247, 170, 53),
                    elevation: 0,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  // margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
          ),

          // Loading
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 130, 200, 58))),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
