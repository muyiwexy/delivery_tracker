import 'package:delivery_tracker/auth/app_provider.dart';
import 'package:delivery_tracker/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstItem extends StatefulWidget {
  const FirstItem({super.key});

  @override
  State<FirstItem> createState() => _FirstItemState();
}

class _FirstItemState extends State<FirstItem> {
  List<String> items = ["Home", "Settings", "Sign Out"];
  String selectedTimeOptions = 'Home';
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, state, child) {
        return Container(
            height: 50,
            padding:const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                        style: BorderStyle.solid))),
            child: Center(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ));
                          },
                          child: const Text(
                            "Food Tracker",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          )),
                    ),
                    SizedBox(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Settings",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Support",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                            )),
                        if (state.user != null)
                          const SizedBox(
                            width: 50.0,
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.blueGrey,
                          
                            ),
                          )
                        else
                          TextButton(
                              onPressed: () async {
                                state.checkAccount(context);
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800),
                              )),
                      ],
                    )
                        )
                  ]),
            ));
      },
    );
  }
}
