import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:railways/cards/train_list_info_card.dart';
import 'package:railways/pages/add_passenger_and_contatc_details.dart';
import 'package:railways/pages/myBookingsDetailsPage.dart';
import 'package:railways/pages/view_route.dart';

import '../ticket download/pdf_generator.dart';
import '../ticket download/ticket_data.dart';

class MybookingsCard extends StatefulWidget {
  final snap;
  final uid;

  const MybookingsCard({
    super.key,
    required this.snap,
    required this.uid,
  });

  @override
  State<MybookingsCard> createState() => _MybookingsCardState();
}

class _MybookingsCardState extends State<MybookingsCard> {
  var snap;

  String trainame = '';
  String fromStationName = '';
  String toStationName = '';
  String fromTime = '';
  String toTime = '';
  int distance = 0;
  int seatsPerCoach = 0;
  DateTime time = DateTime.now();
  Map newMap = {};
  List<dynamic> stations = [];

  // @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  // fetch data from train dataset
  getdata() async {
    print('controller 01');
    // print(widget.snap['TrainId']);

    try {
      snap = await FirebaseFirestore.instance
          .collection('trains')
          .doc(widget.snap['TrainId'])
          .get();
    } on FirebaseException catch (e) {
      print(e);
    }

    print(snap);

    print('controller 01');

    setState(() {
      trainame = snap.data()!['name'];
      fromStationName =
          snap.data()!['stations'][widget.snap['from station index']];
      toStationName = snap.data()!['stations'][widget.snap['to station index']];
      time = snap
          .data()!['station times'][widget.snap['from station index']]
          .toDate();

      fromTime = DateFormat('MMM d, h:mm a').format(time);

      time = snap
          .data()!['station times'][widget.snap['to station index']]
          .toDate();

      toTime = DateFormat('MMM d, h:mm a').format(time);
      distance = snap.data()!['distance'][widget.snap['to station index']] -
          snap.data()!['distance'][widget.snap['from station index']];

      seatsPerCoach = snap.data()!['seats per couche'];

      newMap = snap.data()!['station seats availablity'];

      stations = snap.data()!['stations'];

      for (int i = widget.snap['from station index'];
          i < widget.snap['to station index'];
          i++) {
        for (int j = 0; j < widget.snap['seats'].length; j++) {
          newMap[snap.data()!['stations'][i]].add(widget.snap['seats'][j]);
        }
      }
    });

    print(trainame);
    print(fromStationName);
    print(toStationName);
    print(fromTime);
    print(toTime);
    print(distance);
    print(seatsPerCoach);
  }

  //pdf ticket generator
  Future<void> _downloadTicket(BuildContext context) async {
    List<Passenger> passengers = [];

    print('download pressed');

    for (int i = 0; i < widget.snap['passenger'].length; i++) {
      int selectedCoach = widget.snap['seats'][i] ~/ seatsPerCoach + 1;
      int seatNumber =
          widget.snap['seats'][i] - (selectedCoach - 1) * seatsPerCoach;

      // print('selected coach details');
      // print(selectedCoach);
      // print(seatNumber);

      passengers.add(Passenger(
        name: '${widget.snap['passenger'][i]}',
        seatNo: '$seatNumber (coach  $selectedCoach)',
      ));
    }
    final TicketData ticketData = TicketData(
      trainName: trainame,
      fromStation: fromStationName,
      toStation: toStationName,
      transactionId: widget.snap['TransactionId'],
      trainId: widget.snap['TrainId'],
      passengers: passengers,
    );

    final Uint8List pdfData = await generateTicketPdf(ticketData);

    await Printing.layoutPdf(onLayout: (format) async => pdfData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 100, vertical: 2).copyWith(top: 5),
      child: Card(
        elevation: 2,
        child: Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Row(
                  children: [
                    Text(
                      trainame.toUpperCase(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      '( ${widget.snap['TrainId']})',
                      style:
                          TextStyle(fontWeight: FontWeight.w200, fontSize: 15),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(fromTime),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Icon(CupertinoIcons.arrow_right),
                            ),
                            Text(toTime.toString())
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              fromStationName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 75),
                              child: Icon(
                                CupertinoIcons.tram_fill,
                                size: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 65),
                              child: Text('$distance km'
                                  // '$distance km'
                                  ),
                            ),
                            Text(
                              toStationName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),

              //start and end stations

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    trainListInfoCard('amount paid',
                        int.parse(widget.snap['amount'].toString()).toString()),
                    SizedBox(
                      width: 50,
                    ),

                    Spacer(),

                    //download ticket button
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 5),
                      child: InkWell(
                        onTap: () {
                          _downloadTicket(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            height: 50,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              'Download Ticket',
                              style: TextStyle(fontSize: 17),
                            )),
                          ),
                        ),
                      ),
                    ),

                    // view details button

                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyBookingsDetailsPage(
                              snap: widget.snap,
                              trainName: trainame,
                              fromStationName: fromStationName,
                              toStationName: toStationName,
                              fromTime: fromTime,
                              toTime: toTime,
                              distance: distance,
                              uid: widget.uid,
                              newMap: newMap,
                              stations: stations,
                            ),
                          ));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text('View Details',
                                    style: TextStyle(fontSize: 17))),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
