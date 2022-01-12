/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<TimeSeriesRegisteration> data;
  const SimpleTimeSeriesChart({
    Key? key,required this.data
  }) : super(key: key);

  /// Creates a [TimeSeriesChart] with sample data and no transition.

  @override
  Widget build(BuildContext context) {
   List<charts.Series<TimeSeriesRegisteration, DateTime>> seriesList = [
    charts.Series<TimeSeriesRegisteration, DateTime>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (TimeSeriesRegisteration sales, _) => sales.registerDate,
      measureFn: (TimeSeriesRegisteration sales, _) => sales.person,
      data: data,
    )
  ];
    return charts.TimeSeriesChart(
      seriesList,
      animate: true,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
}

/// Sample time series data type.
class TimeSeriesRegisteration {
  final DateTime registerDate;
  final int person;

  TimeSeriesRegisteration(this.registerDate, this.person);
}
