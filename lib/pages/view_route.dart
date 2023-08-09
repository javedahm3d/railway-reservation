import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:railways/components/my_appbar.dart';

class ViewTrainRoute extends StatefulWidget {
  final snap;
  const ViewTrainRoute({super.key, required this.snap});

  @override
  State<ViewTrainRoute> createState() => _ViewTrainRouteState();
}

class _ViewTrainRouteState extends State<ViewTrainRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 209, 225, 238),
      appBar: MyAppBar(),
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Container(
              width: double.infinity,
              height: 500,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Train Name route Details'),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Table(
                      border: TableBorder.all(color: Colors.grey.shade100),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                            decoration:
                                BoxDecoration(color: Colors.orangeAccent),
                            children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Sr.No'),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Station'),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Arrival'),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Distance'),
                                  )),
                            ]),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: widget.snap['stations'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                width: 250,
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24),
                                  ),
                                )),
                            Container(
                                width: 250,
                                child: Center(
                                  child: Text(
                                    widget.snap['stations'][index].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24),
                                  ),
                                )),
                            Container(
                                width: 250,
                                child: Center(
                                  child: Text(
                                    DateFormat('MMM d, h:mm a').format(widget
                                        .snap['station times'][index]
                                        .toDate()),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24),
                                  ),
                                )),
                            Container(
                                width: 250,
                                child: Center(
                                    child: Text(
                                  widget.snap['distance'][index].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24),
                                ))),
                          ],
                        ),
                      );
                    },
                  ))
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
