import 'package:flutter/material.dart';
import 'package:railways/components/my_appbar.dart';

class PassengerAndContactDeatilsPage extends StatefulWidget {
  const PassengerAndContactDeatilsPage({super.key});

  @override
  State<PassengerAndContactDeatilsPage> createState() =>
      _PassengerAndContactDeatilsPageState();
}

class _PassengerAndContactDeatilsPageState
    extends State<PassengerAndContactDeatilsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
    );
  }
}
