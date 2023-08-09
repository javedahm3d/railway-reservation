import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:railways/cards/train_card.dart';
import 'package:railways/components/my_appbar.dart';
import 'package:railways/pages/train_list_page.dart';

import '../services/station_suggestion.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  DateTime date = DateTime.now();
  int selectedSearchOption = 0;

// text ahead field function
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

// search menu options
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
            color: selectedSearchOption == menuindex
                ? Colors.blue
                : Colors.grey.shade600,
            fontWeight: FontWeight.w600),
      ),
    );
  }

// show date picker

  _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        date = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: const MyAppBar(),

      //body
      body: Column(
        children: [
          //upper body part
          Expanded(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.837,

              //background taj image
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'lib/images/train_bg.jpg',
                      ),
                      fit: BoxFit.fitWidth)),

              //title content
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'Easy Train Ticket Booking',
                    style: GoogleFonts.outfit(
                        fontSize: 70,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 22,
                  ),

                  //inner white box
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60)),
                    child: Container(
                      width: 1300,
                      height: 180,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(155, 209, 225, 238),
                          borderRadius: BorderRadius.circular(15)),

                      //train search options ------------------------------------------------------------------------
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SearchMenuOption('Search By Stations', 1),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2),
                            child: Divider(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 60,
                              ),

                              //typeaheadfield for from station
                              myTextAheadField('Enter From Station', true),

                              //arrow icon inbetween stations
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(
                                  Icons.arrow_forward,
                                ),
                              ),

                              //typeaheadfield for from station
                              myTextAheadField('Enter To Station', false),

                              const SizedBox(
                                width: 20,
                              ),

                              // calendar to select date
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: _showDatePicker,
                                child: Container(
                                    width: 170,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlue.shade300,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Icon(
                                            CupertinoIcons.calendar,
                                            color: Colors.white,
                                            weight: 70,
                                            size: 40,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            DateFormat.MMMEd().format(date),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                              const Spacer(),

                              //search button

                              Padding(
                                padding: const EdgeInsets.only(right: 110),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => TrainListPage(
                                        fromstationController: fromController,
                                        tostationController: toController,
                                        date: date,
                                      ),
                                    ));
                                  },
                                  child: Container(
                                    width: 170,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
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

                  //webiste introduction
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 60, horizontal: 200),
                    child: Text(
                      'Welcome to Easy Rail - Your one-stop online destination for hassle-free train ticket bookings. Discover a seamless booking experience, real-time availability, and secure payments. Embark on memorable train journeys with ease, all at Easy Rail.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee(
                          fontSize: 20,
                          color: Color.fromARGB(167, 255, 255, 255)),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 40,
            color: Colors.grey.shade800,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Copyright reserved by @EasyRail.com  2023',
                  style: TextStyle(
                      color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
