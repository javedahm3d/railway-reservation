import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditTrainPage extends StatefulWidget {
  final snap;

  const EditTrainPage({
    super.key,
    required this.snap,
  });

  @override
  _EditTrainPageState createState() => _EditTrainPageState();
}

class _EditTrainPageState extends State<EditTrainPage> {
  TextEditingController trainNameController = TextEditingController();
  TextEditingController numberOfcoachesController = TextEditingController();
  TextEditingController numberOfSeatsPercoacheController =
      TextEditingController();
  TextEditingController fairController = TextEditingController();

  List<TextEditingController> stationList = [];
  List<TextEditingController> distanceList = [];
  List<DateTime> timestampStation = [];

  // String trainName = '';
  String trainId = '';
  // int numberOfcoaches = 0;
  // int numberOfSeatsPercoache = 0;
  // double fair = 0;
  List<int> seatsAvailable = [];
  List<int> totalSeats = [];
  // List<String> stationList = [];
  // List<int> distanceList = [];
  // List<DateTime?> timestampStation = [];
  Map stationSeatMap = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    setState(() {
      trainId = widget.snap['id'];
      trainNameController.text = widget.snap['name'];
      numberOfcoachesController.text = widget.snap['coaches'].toString();
      numberOfSeatsPercoacheController.text =
          widget.snap['seats per couche'].toString();
      fairController.text = widget.snap['fair'].toString();

      List<dynamic> stations = widget.snap[
          'stations']; // Assuming widget.snap['stations'] is an array of strings

      List<dynamic> stationDistances = widget.snap['distance'];

      List<dynamic> timestampArray =
          widget.snap['station times']; // Assuming it's an array of timestamps
      // List<dynamic> timestampStrings = [];

      for (dynamic timestamp in timestampArray) {
        DateTime timestampString = timestamp.toDate();
        timestampStation.add(timestampString);
      }

// Create TextEditingControllers based on the firebase data
      for (String stationName in stations) {
        TextEditingController controller =
            TextEditingController(text: stationName);
        stationList.add(controller);
      }

      for (dynamic stationDistance in stationDistances) {
        TextEditingController controller =
            TextEditingController(text: stationDistance.toString());
        distanceList.add(controller);
      }
    });
  }

  void _addStation() {
    setState(() {
      stationList.add('' as dynamic);
      distanceList.add(0 as dynamic);
      timestampStation.add(0 as dynamic);
    });
  }

  void _removeStation(int index) {
    // setState(() {
    //   stationList.removeAt(index);
    //   distanceList.removeAt(index);
    //   timestampStation.remove(index);
    // });
  }

  Future<void> _selectDateTime(int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2024),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          timestampStation[index] = selectedDateTime;
        });
      }
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: Column(
          children: [
            //id name coaches
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 400,
                      child: TextField(
                        decoration: InputDecoration(labelText: 'Train Name'),
                        controller: trainNameController,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 400,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration:
                            InputDecoration(labelText: 'Number of Coaches'),
                        controller: numberOfcoachesController,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //seats fair
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 400,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            labelText: 'Number of Seats per Coach'),
                        controller: numberOfSeatsPercoacheController,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 400,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Price per km'),
                        controller: fairController,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(
                children: [
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Add route details:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: stationList.length,
                    itemBuilder: (context, index) {
                      final selectedDateTime = timestampStation[index];

                      // int num = index + 1;

                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  labelText: 'Station ${index + 1}'),
                              controller: stationList[index],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDateTime(index),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Time at Station',
                                ),
                                child: Text(
                                  selectedDateTime != null
                                      ? '${selectedDateTime.toLocal()}'
                                      : 'Select Time', // Provide a placeholder text if no time is selected.
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration:
                                  InputDecoration(labelText: 'Distance'),
                              controller: distanceList[index],
                            ),
                          ),
                          SizedBox(width: 15),
                          IconButton(
                              onPressed: () {
                                _removeStation(index);
                              },
                              icon: Icon(CupertinoIcons.xmark_circle))
                        ],
                      );
                    },
                  ),

//add station button

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: _addStation,
                      child: Text('Add Station'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () async {
                var stations = stationList.map((e) => e.text);
                var distance = distanceList.map((e) => int.parse(e.text));
                var times = timestampStation.map((e) => e);
//adding train logic

                for (int i = 0; i < stationList.length; i++) {
                  seatsAvailable.add(
                      int.parse(numberOfSeatsPercoacheController.text) *
                          int.parse(numberOfcoachesController.text));
                }

                print(seatsAvailable);

                for (int i = 1;
                    i <=
                        int.parse(numberOfcoachesController.text) *
                            int.parse(numberOfSeatsPercoacheController.text);
                    i++) {
                  totalSeats.add(i);
                }

                for (int i = 0; i < stationList.length; i++) {
                  stationSeatMap[stations.elementAt(i)] = totalSeats;
                }

                // print(stationSeatMap);
                // print(stationList.length);
                print(trainId);
                print("up");
                try {
                  print("in");

                  FirebaseFirestore.instance
                      .collection('trains')
                      .doc(trainId)
                      .update({
                    "name": trainNameController.text,
                    // "id": trainId,
                    'fair': double.parse(fairController.text),
                    "stations": stations,
                    "distance": distance,
                    'start time':
                        DateFormat('ddMMyy').format(timestampStation[0]),
                    'end time': DateFormat('ddMMyy')
                        .format(timestampStation[timestampStation.length - 1]),
                    "station times": times,
                    'coaches': int.parse(numberOfcoachesController.text),
                    'seats per couche':
                        int.parse(numberOfSeatsPercoacheController.text),
                    'seats available': seatsAvailable,
                    'iteration': 0,
                    'Jiteration':
                        (int.parse(numberOfcoachesController.text) - 1) / 2,
                    'station seats availablity': stationSeatMap,
                  });
                } on FirebaseException catch (e) {
                  print(e);
                }

                print('Submitted');

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Updated'),
                      content: Text(''),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => AdminHomePage()));
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    'Submit Details',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
            )
//
          ],
        ),
      ),
    );
  }
}
