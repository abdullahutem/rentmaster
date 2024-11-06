import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rentmaster/constans/my_colors.dart';

class RealStateScreen extends StatefulWidget {
  const RealStateScreen({super.key});

  @override
  State<RealStateScreen> createState() => _RealStateScreenState();
}

class _RealStateScreenState extends State<RealStateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: const Text("إنشاء نوع للعقارات"),
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(child: Text("data"),),
    );
  }
}