import 'package:flutter/material.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            children: [Text(widget.snap['name'])],
          ),
        ),
      ),
    );
  }
}
