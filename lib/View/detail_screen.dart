import 'package:covid_19_tracker/View/world_states.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String name;
  final int totalCases,
      totalDeaths,
      totalRecovered,
      active,
      critical,
      todayRecovered,
      test;
  const DetailScreen({
    super.key,
    required this.image,
    required this.name,
    this.totalCases = 0,
    this.totalDeaths = 0,
    this.totalRecovered = 0,
    this.active = 0,
    this.critical = 0,
    this.todayRecovered = 0,
    this.test = 0,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(alignment: Alignment.topCenter, children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .067),
                child: Card(
                  child: Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .06,
                    ),
                    ReusableRow(
                        title: 'Cases', value: widget.totalCases.toString()),
                    ReusableRow(
                        title: 'Recovered',
                        value: widget.totalRecovered.toString()),
                    ReusableRow(
                        title: 'Death', value: widget.totalDeaths.toString()),
                    ReusableRow(
                        title: 'Critical', value: widget.critical.toString()),
                    ReusableRow(
                        title: 'Today Recovered',
                        value: widget.totalRecovered.toString()),
                  ]),
                ),
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.image),
              )
            ])
          ]),
    );
  }
}
