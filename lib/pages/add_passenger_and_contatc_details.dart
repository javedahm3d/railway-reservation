import 'package:flutter/material.dart';

class ScheduleDetailsPage extends StatefulWidget {
  @override
  _ScheduleDetailsPageState createState() => _ScheduleDetailsPageState();
}

class _ScheduleDetailsPageState extends State<ScheduleDetailsPage> {
  int scheduleId = 0;
  String trainId = '';
  List<String> passengerList = [];
  List<String> age = [];
  List<String> gender = [];

  void _addStation() {
    setState(() {
      passengerList.add('');
      age.add('');
      gender.add('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Train Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Schedule ID'),
              onChanged: (value) {
                setState(() {
                  scheduleId = int.parse(value);
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Train ID'),
              onChanged: (value) {
                setState(() {
                  trainId = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Stations:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                for (int i = 0; i < passengerList.length; i++)
                  _buildStationRow(i),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addStation,
              child: Text('Add Station'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Perform action with the entered train details
                // You can access trainName, trainId, stations, timesAtStations, and distances here.
                print('Train Name: $scheduleId');
                print('Train ID: $trainId');
                print('Stations: $passengerList');
                print('Distance: $age');
                print('Time: $gender');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationRow(int index) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: 'Station ${index + 1}'),
            onChanged: (value) {
              setState(() {
                passengerList[index] = value;
              });
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: 'Time at Station'),
            onChanged: (value) {
              setState(() {
                gender[index] = value;
              });
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TextField(
            decoration: InputDecoration(labelText: 'Distance'),
            onChanged: (value) {
              setState(() {
                age[index] = value;
              });
            },
          ),
        ),
      ],
    );
  }
}

//radio buttons options logic

enum SingingCharacter { male, female }

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  SingingCharacter? _character = SingingCharacter.male;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('male'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.male,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('female'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.female,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
