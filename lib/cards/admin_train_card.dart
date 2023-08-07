import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:railways/cards/train_list_info_card.dart';
import 'package:railways/pages/add_passenger_and_contatc_details.dart';
import 'package:railways/pages/view_route.dart';

class AdminTrainListCard extends StatefulWidget {
  final snap;
  final trainId;
  const AdminTrainListCard({
    super.key,
    required this.snap,
    required this.trainId,
  });

  @override
  State<AdminTrainListCard> createState() => _AdminTrainListCardState();
}

class _AdminTrainListCardState extends State<AdminTrainListCard> {
  // int distance = 0;
  // int fair = 0;

  // @override
  // void initState() {
  //   TODO: implement initState
  //   super.initState();
  //   print("-------------------------------------------------------------");
  //   print(widget.toIndex.abs());
  //   print(widget.fromIndex.abs());
  // }

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
                      widget.snap["name"],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      '( ${widget.snap["id"]})',
                      style:
                          TextStyle(fontWeight: FontWeight.w200, fontSize: 15),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(DateFormat('MMM d, h:mm a').format(
                                widget.snap['station times'][0].toDate())),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Icon(CupertinoIcons.arrow_right),
                            ),
                            Text(DateFormat('MMM d, h:mm a').format(widget
                                .snap['station times']
                                    [widget.snap['station times'].length - 1]
                                .toDate()))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              widget.snap['stations'][0],
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
                              child: Text(
                                  '${widget.snap['distance'][widget.snap['station times'].length - 1] - widget.snap['distance'][0]} km'
                                  // '$distance km'
                                  ),
                            ),
                            Text(
                                widget.snap['stations']
                                    [widget.snap['station times'].length - 1],
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                    SizedBox(
                      width: 50,
                    ),
                    trainListInfoCard('fair',
                        '₹${widget.snap['fair'] * (widget.snap['distance'][widget.snap['station times'].length - 1] - widget.snap['distance'][0])}'),

                    SizedBox(
                      width: 50,
                    ),
                    trainListInfoCard('Waiting List', '0'),

                    Spacer(),

                    // book train button

                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 5),
                      child: InkWell(
                        onTap: () {},
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            height: 50,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                                child: Text(
                              'update details',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
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
