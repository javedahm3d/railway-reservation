import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/homepage.dart';

class RefundsPage extends StatefulWidget {
  const RefundsPage({super.key});

  @override
  State<RefundsPage> createState() => _RefundsPageState();
}

class _RefundsPageState extends State<RefundsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 209, 225, 238),
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
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('refund').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.length == 0) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(child: Text('no active refunds')),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.all(8.0).copyWith(left: 20),
                            child: Text(
                              snapshot.data!.docs[index]
                                  .data()['transaction id']
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(8.0).copyWith(left: 15),
                            child: ElevatedButton(
                                onPressed: () {
                                  final data = ClipboardData(
                                      text: snapshot.data!.docs[index]
                                          .data()['transaction id']);
                                  Clipboard.setData(data);
                                },
                                child: Text(
                                  'copy',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {}, child: Text('active')),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
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
    );
  }
}
