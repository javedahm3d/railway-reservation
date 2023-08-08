import 'package:flutter/material.dart';
import 'package:railways/cards/mybookingsCard.dart';
import 'package:railways/components/my_appbar.dart';

class MyBookingsDetailsPage extends StatefulWidget {
  final snap;
  final trainName;
  final fromStationName;

  final toStationName;
  final fromTime;
  final toTime;
  final distance;

  const MyBookingsDetailsPage(
      {super.key,
      required this.snap,
      required this.trainName,
      required this.fromStationName,
      required this.toStationName,
      required this.fromTime,
      required this.toTime,
      required this.distance});

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
                    Text('train id: ${widget.snap['trainId']}'),
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
                    // InkWell(
                    //   onTap: () {

                    //   },
                    //   child: Container(
                    //     width: 170,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //         color: Colors.orange,
                    //         borderRadius: BorderRadius.circular(20)),
                    //     child: Center(
                    //       child: Text(
                    //         'Download Ticket',
                    //         style: TextStyle(
                    //             fontSize: 18, fontWeight: FontWeight.w800),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
