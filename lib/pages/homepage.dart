import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../services/station_suggestion.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  int selectedSearchOption = 0;

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
            controller: isFromStation ? fromController : toController,
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
                ? fromController.text = suggestion
                : toController.text = suggestion;
          });
        },
      ),
    );
  }

  SearchMenuOption(String optionName, int menuindex) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        if (value) {
          setState(() {
            selectedSearchOption = menuindex;
          });
        } else {
          setState(() {
            selectedSearchOption = 0;
          });
        }
      },
      child: Text(
        optionName,
        style: TextStyle(
            fontSize: 20,
            color:
                selectedSearchOption == menuindex ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  _showDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade100,
        title: Row(
          children: [
            //app logo
            Icon(
              Icons.train,
              size: 30,
              color: Colors.black,
            ),

            Text(
              'EasyRail',
              style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: InkWell(
                onTap: () {},
                child: Text('my bookings',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: Text('logout',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: InkWell(
                onTap: () {},
                child: Text('admin login',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black)),
              ),
            ),
          )
        ],
      ),

      //body
      body: Column(
        children: [
          //upper body part
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.45,

            //background taj image
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'lib/images/train_bg.jpg',
                    ),
                    fit: BoxFit.fitWidth)),

            //upper body content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  'Easy Train Ticket Booking',
                  style: TextStyle(
                      fontSize: 70,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),

                //inner white box
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(20)),

                  //train search options ------------------------------------------------------------------------
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SearchMenuOption('Search By Staions', 1),
                            SearchMenuOption('Search By Train Name', 2),
                            SearchMenuOption('Search By Train Id', 3),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
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
                                      weight: 100,
                                      size: 50,
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('trains')
                    // .where('name', isGreaterThanOrEqualTo: _searchController.text)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  print(snapshot);
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 300,
                          height: 100,
                          color: Colors.black,
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
