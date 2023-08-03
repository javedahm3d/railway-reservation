import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:railways/cards/train_list_info_card.dart';

class TrainListCard extends StatefulWidget {
  final snap;
  const TrainListCard({super.key, required this.snap});

  @override
  State<TrainListCard> createState() => _TrainListCardState();
}

class _TrainListCardState extends State<TrainListCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 100, vertical: 2).copyWith(top: 5),
      child: Card(
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
                    Text(widget.snap['station times'][0]),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Icon(CupertinoIcons.forward),
                    ),
                    Text(widget.snap['station times']
                        [widget.snap['station times'].length - 1])
                  ],
                ),
              ),

              //start and end stations
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(widget.snap['stations'][0]),
                  SizedBox(
                    width: 100,
                  ),
                  Text(widget.snap['stations']
                      [widget.snap['stations'].length - 1]),
                  SizedBox(
                    width: 35,
                  )
                ],
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    trainListInfoCard('Number Of Seats Available',
                        widget.snap['available seats']),
                    SizedBox(
                      width: 50,
                    ),
                    trainListInfoCard('fair', widget.snap['fair']),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: InkWell(
                        onTap: () {},
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text('view Route')),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 5),
                      child: InkWell(
                        onTap: () {},
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text('Book Ticket')),
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
