import 'package:flutter/material.dart';

import '../methods/common_methods.dart';
import '../widgets/trips_data_list.dart';

class TripsPage extends StatefulWidget {
  static const String id = "\webPageTrips";

  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  CommonMethods cMethods = CommonMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "Yolculuk Yönetimi",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                children: [
                  cMethods.header(2, "YOLCULUK NO"),
                  cMethods.header(1, "YOLCU"),
                  cMethods.header(1, "SÜRÜCÜ"),
                  cMethods.header(1, "ARAÇ"),
                  cMethods.header(1, "TARİH"),
                  cMethods.header(1, "ÜCRET"),
                  cMethods.header(1, "DETAY"),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              //display data
              const TripsDataList(),
            ],
          ),
        ),
      ),
    );
  }
}
