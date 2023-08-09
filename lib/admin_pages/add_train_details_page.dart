import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:railways/components/show_message.dart';

import '../services/station_suggestion.dart';

class AddNewTrainPage extends StatefulWidget {
  @override
  _AddNewTrainPageState createState() => _AddNewTrainPageState();
}

class _AddNewTrainPageState extends State<AddNewTrainPage> {
  String trainName = '';
  String trainId = '';
  int numberOfcoaches = 0;
  int numberOfSeatsPercoache = 0;
  double fair = 0;
  List<int> seatsAvailable = [];
  List<int> totalSeats = [];
  List<String> stationList = [];
  List<int> distanceList = [];
  List<DateTime?> timestampStation = [];
  Map stationSeatMap = {};
  List<TextEditingController> controller = [];

  void _addStation() {
    setState(() {
      controller.add(TextEditingController());
      stationList.add('');
      distanceList.add(0);
      timestampStation.add(null);
    });

    print(controller[0].text);
  }

  void _removeStation(int index) {
    setState(() {
      controller.removeAt(index);
      stationList.removeAt(index);
      distanceList.removeAt(index);
      timestampStation.remove(index);
    });
  }

  Future<void> _selectDateTime(int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
                        decoration: InputDecoration(
                            labelText: 'Train ID',
                            fillColor: Colors.white,
                            focusColor: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            trainId = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 400,
                      child: TextField(
                        decoration: InputDecoration(labelText: 'Train Name'),
                        onChanged: (value) {
                          setState(() {
                            trainName = value;
                          });
                        },
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
                        onChanged: (value) {
                          setState(() {
                            numberOfcoaches = int.parse(value);
                          });
                        },
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
                            labelText: 'Number of seats per coache'),
                        onChanged: (value) {
                          setState(() {
                            numberOfSeatsPercoache = int.parse(value);
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 400,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'price per km'),
                        onChanged: (value) {
                          setState(() {
                            fair = double.parse(value);
                          });
                        },
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

                      int num = index + 1;
                      return Row(
                        children: [
                          Expanded(child: myTextAheadField(index)

                              // TextField(
                              //   decoration: InputDecoration(
                              //       labelText: 'Station ${index + 1}'),
                              //   onChanged: (value) {
                              //     setState(() {
                              //       stationList[index] = value.toLowerCase();
                              //     });
                              //   },
                              // ),
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
                              onChanged: (value) {
                                setState(() {
                                  distanceList[index] = int.parse(value);
                                });
                              },
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
                if (trainName == '') {
                  ShowMessage()
                      .showMessage('train name field is empty', context);
                } else if (trainId == '') {
                  ShowMessage().showMessage('train id field is empty', context);
                } else if (numberOfcoaches == 0) {
                  ShowMessage().showMessage(
                      'number of coaches must not be nil', context);
                } else if (numberOfSeatsPercoache == 0) {
                  ShowMessage().showMessage(
                      'number of seats per coache must not be nil', context);
                } else if (numberOfSeatsPercoache % 6 != 0) {
                  ShowMessage().showMessage(
                      'number of seats per coache must not be in a multiple of 6',
                      context);
                } else if (fair == 0) {
                  ShowMessage()
                      .showMessage('prize per km field is empty', context);
                }
//adding train logic

                else {
                  for (int i = 0; i < stationList.length; i++) {
                    seatsAvailable
                        .add(numberOfSeatsPercoache * numberOfcoaches);
                  }

                  print(seatsAvailable);

                  for (int i = 1;
                      i <= numberOfcoaches * numberOfSeatsPercoache;
                      i++) {
                    totalSeats.add(i);
                  }

                  for (int i = 0; i < stationList.length - 1; i++) {
                    stationSeatMap[stationList[i]] = totalSeats;
                  }

                  // print(stationSeatMap);
                  // print(stationList.length);

                  try {
                    await FirebaseFirestore.instance
                        .collection('trains')
                        .doc(trainId)
                        .set({
                      "name": trainName.toLowerCase(),
                      "id": trainId,
                      'fair': fair,
                      "stations": stationList,
                      "distance": distanceList,
                      'start time': int.parse(
                          DateFormat('ddMMyy').format(timestampStation[0]!)),
                      'end time': int.parse(DateFormat('ddMMyy').format(
                          timestampStation[timestampStation.length - 1]!)),
                      "station times": timestampStation,
                      'coaches': numberOfcoaches,
                      'seats per couche': numberOfSeatsPercoache,
                      // 'seats available': seatsAvailable,
                      'iteration': 0,
                      'Jiteration': (numberOfcoaches - 1) / 2,
                      'station seats availablity': stationSeatMap,
                    });
                  } on FirebaseException catch (e) {
                    print(e);
                  }

                  print('submitted');

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Form Submitted'),
                        content: Text(''),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
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
          ],
        ),
      ),
    );
  }

  myTextAheadField(int index) {
    return SizedBox(
      height: 50,
      width: 350,
      child: TypeAheadField(
        noItemsFoundBuilder: (context) => const SizedBox(
          height: 50,
          child: Center(
            child: Text('No Stations Found'),
          ),
        ),
        suggestionsBoxDecoration: const SuggestionsBoxDecoration(
            color: Colors.white,
            elevation: 4.0,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )),
        debounceDuration: const Duration(milliseconds: 400),
        textFieldConfiguration: TextFieldConfiguration(
            controller: controller[index],
            decoration: InputDecoration(
                // border: InputBorder,
                hintText: 'station $index',
                fillColor: Colors.white,
                filled: true)),
        suggestionsCallback: (value) {
          return GetStations().getSuggestions(value);
        },
        itemBuilder: (context, String suggestion) {
          return Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    suggestion,
                    maxLines: 1,
                    // style: TextStyle(color: Colors.red),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          );
        },
        onSuggestionSelected: (String suggestion) {
          setState(() {
            // controller.text = suggestion;
            stationList[index] = suggestion;
          });
        },
      ),
    );
  }
}
