import 'package:delivery_tracker/pages/component/HomeComponent/first_column_item.dart';
import 'package:delivery_tracker/pages/component/HomeComponent/second_column_item.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [FirstItem(), SecondItem()],
      ),
    );
  }
}
