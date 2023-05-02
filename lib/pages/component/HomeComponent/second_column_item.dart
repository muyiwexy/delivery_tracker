import 'package:delivery_tracker/pages/views/view_one.dart';
import 'package:delivery_tracker/pages/views/view_three.dart';
import 'package:delivery_tracker/pages/views/view_two.dart';
import 'package:flutter/material.dart';

class SecondItem extends StatefulWidget {
  const SecondItem({Key? key}) : super(key: key);

  @override
  _SecondItemState createState() => _SecondItemState();
}

class _SecondItemState extends State<SecondItem> {
  int _selectedIndex = 0;
  final List<View> _views = [
    View(title: "Home", child: const HomeView(), icons: Icons.home),
    View(title: "Search", child: const SearchView(), icons: Icons.search),
    View(title: "Order", child: const OrderView(), icons: Icons.book),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 200,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: ListView.builder(
                  itemCount: _views.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(_views[index].title),
                    leading: Icon(_views[index].icons),
                    selected: _selectedIndex == index,
                    onTap: () => _onViewSelected(index),
                  ),
                )),
                PopupMenuButton<String>(
                  tooltip: "",
                  child: const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Manage'),
                  ),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                        child: ElevatedButton.icon(
                            onPressed: () {},
                            label: const Text(
                              "Settings",
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.transparent),
                                elevation: MaterialStatePropertyAll<double>(0)),
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.blueGrey,
                            ))),
                    PopupMenuItem<String>(
                        child: ElevatedButton.icon(
                      onPressed: () {},
                      label: const Text("Sign out",
                          style: TextStyle(color: Colors.blueGrey)),
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.transparent),
                          elevation: MaterialStatePropertyAll<double>(0)),
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: Colors.blueGrey,
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (_) => _views[_selectedIndex].child,
              ),
            ),
            )
          ),
        ],
      ),
    );
  }

  void _onViewSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class View {
  final String title;
  final Widget child;
  final IconData icons;

  View({required this.title, required this.child, required this.icons});
}
