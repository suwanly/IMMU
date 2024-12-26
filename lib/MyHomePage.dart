import 'package:flutter/material.dart';
import 'profilepage.dart';
import 'UploadHomePage.dart';
import 'feeddem.dart';

class Mainhomp extends StatefulWidget{
  @override
  MyHomePage createState() => MyHomePage();
}

class MyHomePage extends State<Mainhomp>{
  int i=0;

  List<BottomNavigationBarItem> bottomitems= [
    BottomNavigationBarItem(
      label: 'Feed',
      icon: Icon(Icons.dashboard_outlined),
    ),
    BottomNavigationBarItem(
        label: 'Upload',
        icon: Icon(Icons.arrow_circle_up)
    ),
    BottomNavigationBarItem(
        label: 'Profile',
        icon: Icon(Icons.person_outlined)
    ),
  ];
  List pages=[
    Feed(),
    SNSUploadPage(),
    profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMMU',style: TextStyle(
        fontFamily: 'Mistral', // AppBar에서만 이 폰트 사용
        fontSize: 30,
        color: Colors.white,),)
      ),


      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.withOpacity(.50),
        unselectedFontSize: 10,
        selectedFontSize: 14,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: i,
        onTap: (int index){
          setState((){
            i = index;
          });
        },
        items: bottomitems,
      ),
      body: pages[i],
    );
  }
}