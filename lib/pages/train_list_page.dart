import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:railways/components/my_appbar.dart';
import 'package:railways/pages/homepage.dart';

import '../cards/train_card.dart';
import '../services/station_suggestion.dart';

class TrainListPage extends StatefulWidget {
  TextEditingController fromstationController;
  TextEditingController tostationController;
  DateTime date;
  TrainListPage(
      {super.key,
      required this.fromstationController,
      required this.tostationController,
      required this.date});

  @override
  State<TrainListPage> createState() => _TrainListPageState();
}

class _TrainListPageState extends State<TrainListPage> {
  _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        widget.date = value!;
      });
    });
  }

  myTextAheadField(String hintText, bool isFromStation) {
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
            controller: isFromStation
                ? widget.fromstationController
                : widget.tostationController,
            decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                  15.0,
                )),
                enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                    borderSide: BorderSide(color: Colors.black)),
                hintText: hintText,
                contentPadding: const EdgeInsets.only(top: 4, left: 10),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: Colors.grey)),
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
              const Icon(
                Icons.refresh,
                color: Colors.grey,
              ),
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
            isFromStation
                ? widget.fromstationController.text = suggestion
                : widget.tostationController.text = suggestion;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 209, 225, 238),

      // appbar

      appBar: MyAppBar(),

//body
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Card(
                child: Container(
                  width: 1350,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                          ),

                          //typeaheadfield for from station
                          myTextAheadField('Enter From Station', true),

                          //arrow icon inbetween stations
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.arrow_forward,
                            ),
                          ),

                          //typeaheadfield for from station
                          myTextAheadField('Enter To Station', false),

                          SizedBox(
                            width: 20,
                          ),

                          // calendar to select date
                          MaterialButton(
                            onPressed: _showDatePicker,
                            child: Container(
                                width: 170,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue.shade300,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.calendar,
                                      color: Colors.white,
                                      weight: 70,
                                      size: 40,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        DateFormat.MMMEd().format(widget.date),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          Spacer(),

                          Padding(
                            padding: const EdgeInsets.only(right: 110),
                            child: InkWell(
                              onTap: () {
                                // navigator
                              },
                              child: Container(
                                width: 170,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    'Search',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

//train list details
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('trains')
                    .where('start time', isGreaterThanOrEqualTo: widget.date)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data();

                        if (widget.tostationController.text.isEmpty ||
                            widget.fromstationController.text.isEmpty) {
// Train list card
                          return Center(
                            child: Text('Please select staions'),
                          );
                        } else if (data['stations']
                                .contains(widget.fromstationController.text) &&
                            data['stations']
                                .contains(widget.tostationController.text) &&
                            (data['stations'].indexOf(
                                    widget.fromstationController.text) <
                                data['stations'].indexOf(
                                    widget.tostationController.text))) {
                          // Train list card

                          return TrainListCard(
                            snap: snapshot.data!.docs[index].data(),
                            toIndex: data['stations']
                                .indexOf(widget.tostationController.text),
                            fromIndex: data['stations']
                                .indexOf(widget.fromstationController.text),
                          );
                        } else {
                          return Center(child: Text('no trains found'));
                        }
                      });
                }),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Tech Support',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {},
        child: Container(
          width: 40,
          height: 40,
          child: Icon(CupertinoIcons.text_bubble),
        ),
      ),
    );
  }
}
