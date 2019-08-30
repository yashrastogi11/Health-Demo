import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:health/camera.dart';
import 'package:health/chatbot.dart';
import 'package:health/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  // PageController _pageController;

  final List<Widget> _children = [
    Profile(),
    DialogFlow(),
    Camera(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: false,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
            //  _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
          });
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            activeColor: Color.fromARGB(255, 128, 44, 110),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.message),
            title: Text("ChatBot"),
            activeColor: Color.fromARGB(255, 247, 170, 53),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.camera),
            title: Text("Camera"),
            activeColor: Color.fromARGB(255, 240, 50, 110),
          ),
        ],
      ),
      body: _children[_selectedIndex],
    );
  }
}
