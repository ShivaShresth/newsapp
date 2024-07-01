import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newsapi/pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
Timer(Duration(seconds: 3),(){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));

});

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Container(  
 // color: Colors.blue,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/news.png',height: 160,width: 160,),
      Center(child: Text("News App",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20),)),
    ],
  ),
)

    );
  }
}