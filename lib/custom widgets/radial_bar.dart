import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RadialBar extends StatelessWidget {
  const RadialBar({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: SfCircularChart());
  }
}