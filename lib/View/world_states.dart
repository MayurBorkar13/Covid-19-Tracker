import 'package:covid_19_tracker/Model/world_states_model.dart';
import 'package:covid_19_tracker/Services/states_services.dart';
import 'package:covid_19_tracker/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStates extends StatefulWidget {
  const WorldStates({super.key});

  @override
  State<WorldStates> createState() => _WorldStatesState();
}

class _WorldStatesState extends State<WorldStates>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              FutureBuilder(
                  future: statesServices.fetchWorldStatesRecords(),
                  builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(
                        flex: 1,
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50.0,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Expanded(
                        flex: 1,
                        child: Center(
                          child: Text('Error: ${snapshot.error}'),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Expanded(
                        flex: 1,
                        child: Center(
                          child: Text('No data available'),
                        ),
                      );
                    } else {
                      var data = snapshot.data!;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            PieChart(
                              dataMap: {
                                'Total': (data.cases ?? 0).toDouble(),
                                'Recovered': (data.recovered ?? 0).toDouble(),
                                'Deaths': (data.deaths ?? 0).toDouble(),
                              },
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true,
                              ),
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.0,
                              legendOptions: const LegendOptions(
                                  legendPosition: LegendPosition.left),
                              animationDuration:
                                  const Duration(milliseconds: 1200),
                              chartType: ChartType.ring,
                              colorList: colorList,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.06,
                              ),
                              child: Card(
                                child: Column(
                                  children: [
                                    ReusableRow(
                                      title: 'Total',
                                      value: data.cases?.toString() ?? 'N/A',
                                    ),
                                    ReusableRow(
                                      title: 'Deaths',
                                      value: data.deaths?.toString() ?? 'N/A',
                                    ),
                                    ReusableRow(
                                      title: 'Active',
                                      value: data.active?.toString() ?? 'N/A',
                                    ),
                                    ReusableRow(
                                      title: 'Critical',
                                      value: data.critical?.toString() ?? 'N/A',
                                    ),
                                    ReusableRow(
                                      title: 'Today Deaths',
                                      value:
                                          data.todayDeaths?.toString() ?? 'N/A',
                                    ),
                                    ReusableRow(
                                      title: 'Today Recovered',
                                      value: data.todayRecovered?.toString() ??
                                          'N/A',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CountriesList(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xff1aa260),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Track Countries',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  const ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(height: 5),
          const Divider()
        ],
      ),
    );
  }
}
