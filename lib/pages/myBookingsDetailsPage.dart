import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:railways/cards/mybookingsCard.dart';
import 'package:railways/components/my_appbar.dart';
import 'package:railways/pages/mybookings.dart';

class MyBookingsDetailsPage extends StatefulWidget {
  final snap;
  final trainName;
  final fromStationName;

  final toStationName;
  final fromTime;
  final toTime;
  final distance;
  final uid;
  final Map newMap;
  final stations;

  const MyBookingsDetailsPage(
      {super.key,
      required this.snap,
      required this.trainName,
      required this.fromStationName,
      required this.toStationName,
      required this.fromTime,
      required this.toTime,
      required this.distance,
      required this.uid,
      required this.newMap,
      required this.stations});

  @override
  State<MyBookingsDetailsPage> createState() => _MyBookingsDetailsPageState();
}

class _MyBookingsDetailsPageState extends State<MyBookingsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20), // Adjust horizontal padding
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                width: 500,
                height: 520, // This width might not be necessary
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center-align contents horizontally
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8).copyWith(bottom: 12),
                      child: Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text('transaction id: ${widget.snap['TransactionId']}'),
                    Text('train id: ${widget.snap['TrainId']}'),
                    Text('train name: ${widget.trainName}'),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        'boarding station: ${widget.fromStationName} - ${widget.fromTime}'),
                    Text(
                        'destination station: ${widget.toStationName} - ${widget.toTime}'),
                    Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(bottom: 20),
                      child: Text(
                        'Passenger Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 20, // Adjust the spacing
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                            '      Passenger Name'), // Adjust the text for better alignment
                        Text('Seat Number'),
                        Text('Amount Paid'),
                      ],
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.snap['passenger'].length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(widget.snap['passenger'][
                                  index]), // Adjust the text for better alignment
                              Text(widget.snap['seats'][index].toString()),
                              Text(widget.snap['individual amount'][index]
                                  .toString()),
                            ],
                          );
                        },
                      ),
                    ),

                    // cancel booking button
                    InkWell(
                      onTap: () {
                        bool confirmed = false;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text(
                                  'Your refund will be done within 4-5 working days.'),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    bool isLoading = true;

                                    // Close the dialog
                                    Navigator.of(context)
                                      ..pop()
                                      ..pop();

                                    // Perform data operations
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('refund')
                                          .doc(widget.snap['TransactionId'])
                                          .set({
                                        'uid': widget.uid,
                                        'transaction id':
                                            widget.snap['TransactionId'],
                                        'amount': widget.snap['amount']
                                      });

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.uid)
                                          .collection('bookings')
                                          .doc(widget.snap['TransactionId'])
                                          .delete();

                                      await FirebaseFirestore.instance
                                          .collection('trains')
                                          .doc(widget.snap['TrainId'])
                                          .update({
                                        'station seats availablity':
                                            widget.newMap,
                                      });

                                      var snap1 = await FirebaseFirestore
                                          .instance
                                          .collection('trains')
                                          .doc(widget.snap['TrainId'])
                                          .collection('bookings')
                                          .doc(widget.stations[widget
                                                  .snap['from station index']]
                                              .toString())
                                          .get();

                                      List<String> transaction = [];
                                      List<String> passenger = [];
                                      List<int> seats = [];
                                      List<int> age = [];
                                      setState(() {
                                        transaction =
                                            snap1.data()!['TransactionId'];
                                        passenger = snap1.data()!['passenger'];
                                        seats = snap1.data()!['seats'];
                                        age = snap1.data()!['age'];

                                        transaction = transaction +
                                            widget.snap['TransactionId'];
                                        passenger = passenger +
                                            widget.snap['passenger'];
                                        seats = seats + widget.snap['seats'];
                                        age = age + widget.snap['age'];
                                      });

                                      await FirebaseFirestore.instance
                                          .collection('trains')
                                          .doc(widget.snap['TrainId'])
                                          .collection('bookings')
                                          .doc(widget.stations[widget
                                                  .snap['from station index']]
                                              .toString())
                                          .update({
                                        'TransactionId': transaction,
                                        'passenger': passenger,
                                        'age': age,
                                        'seats': seats,
                                      });
                                      Navigator.of(context).pop();
                                    } catch (e) {
                                      print(e);
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 170,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            'Cancel Booking',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
