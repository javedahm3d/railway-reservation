import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:railways/admin_pages/add_train_details_page.dart';
import 'package:railways/admin_pages/refund.dart';
import 'package:railways/cards/admin_train_card.dart';
import 'package:railways/components/my_appbar.dart';
import 'package:railways/pages/homepage.dart';

import '../cards/train_card.dart';
import '../services/station_suggestion.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({
    super.key,
  });

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  DateTime date = DateTime.now();
  TextEditingController trainIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (value) {
        if (value.isKeyPressed(LogicalKeyboardKey.enter)) {
          print('enter pressed');
          setState(() {
            trainIdController = trainIdController;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(221, 209, 225, 238),

        // appbar

        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.deepPurple,
          title: Row(
            children: [
              //app logo
              Icon(
                Icons.train,
                size: 40,
                color: Colors.white,
              ),

              Text(
                'EasyRail Admin Portal',
                style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                width: 450,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1)),
                child: TextField(
                  controller: trainIdController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search With Train ID',
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700])),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  setState(() {
                    trainIdController = trainIdController;
                  });
                },
                child: Container(
                  width: 160,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Search',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),

        //body
        body: Column(
          children: [
            //train list details
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('trains')
                      .where('id',
                          isGreaterThanOrEqualTo: trainIdController.text)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs.length == 0) {
                      return Center(
                        child: Text(
                            'no train with the entered train id available'),
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data();

                          return AdminTrainListCard(
                              snap: snapshot.data!.docs[index].data(),
                              trainId: trainIdController.text);
                        });
                  }),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          tooltip: 'add new train',
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddNewTrainPage()));
          },
          child: Container(
            width: 40,
            height: 40,
            child: Icon(CupertinoIcons.add),
          ),
        ),

        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(),
                  )),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: 40,
                    ),
                    title: Text(
                      'User Dashboard',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RefundsPage(),
                  )),
                  child: ListTile(
                    leading: Icon(
                      Icons.money,
                      size: 40,
                    ),
                    title: Text(
                      'Refunds',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
