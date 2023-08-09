import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:railways/cards/train_list_info_card.dart';
import 'package:railways/pages/add_passenger_and_contatc_details.dart';
import 'package:railways/pages/view_route.dart';

class TrainListCard extends StatefulWidget {
  final snap;
  final int fromIndex;
  final int toIndex;
  const TrainListCard(
      {super.key,
      required this.snap,
      required this.fromIndex,
      required this.toIndex});

  @override
  State<TrainListCard> createState() => _TrainListCardState();
}

class _TrainListCardState extends State<TrainListCard> {
  List<int> commonSeats = [];

  // @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<List<dynamic>> matrix = [];

    for (int i = widget.fromIndex; i < widget.toIndex; i++) {
      matrix.add(widget.snap['station seats availablity']
          ["${widget.snap['stations'][i]}"]);
    }
    setState(() {
      commonSeats = getCommonSeats(matrix);
    });

    print(commonSeats);
  }

  // function to select common seats in between stations
  List<int> getCommonSeats(List<List<dynamic>> matrix) {
    if (matrix.isEmpty) {
      return [];
    }
    Set<int> commonSeats = Set.from(matrix.first);
    for (var i = 1; i < matrix.length; i++) {
      Set<int> currentSet = Set.from(matrix[i]);
      // Perform intersection to get common Seats with the previous set
      commonSeats = commonSeats.intersection(currentSet);
    }

    return commonSeats.toList();
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
                            Text(DateFormat('MMM d, h:mm a').format(widget
                                .snap['station times'][widget.fromIndex]
                                .toDate())),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Icon(CupertinoIcons.arrow_right),
                            ),
                            Text(DateFormat('MMM d, h:mm a').format(widget
                                .snap['station times'][widget.toIndex]
                                .toDate()))
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              widget.snap['stations'][widget.fromIndex],
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
                                  '${widget.snap['distance'][widget.toIndex] - widget.snap['distance'][widget.fromIndex]} km'
                                  // '$distance km'
                                  ),
                            ),
                            Text(widget.snap['stations'][widget.toIndex],
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
                    trainListInfoCard('Number Of Seats Available',
                        commonSeats.length.toString()),
                    SizedBox(
                      width: 50,
                    ),
                    trainListInfoCard('fair',
                        '₹${int.parse('${widget.snap['fair'] * (widget.snap['distance'][widget.toIndex] - widget.snap['distance'][widget.fromIndex])}')}'),

                    SizedBox(
                      width: 50,
                    ),
                    trainListInfoCard('Waiting List', '0'),

                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),

                      // view route button

                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewTrainRoute(
                              snap: widget.snap,
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
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text('view Route')),
                          ),
                        ),
                      ),
                    ),

                    // book train button

                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                PassengerAndContactDeatilsPage(
                              snap: widget.snap,
                              fromIndex: widget.fromIndex,
                              toIndex: widget.toIndex,
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
