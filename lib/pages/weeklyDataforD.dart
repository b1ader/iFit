import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:googlelogin/Component/Repository.dart';
import 'package:googlelogin/design/colors.dart';
import 'package:intl/intl.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

final date = DateTime.now();

class SimpleBarChartD extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;
  final String title;

  SimpleBarChartD(this.seriesList,
      {required this.animate, required this.title});

  /// Creates a [BarChart] with sample data and no transition.
  ///
  ///

  factory SimpleBarChartD.withSampleData(List<double?> steps, String titlee) {
    return new SimpleBarChartD(
      title: titlee,
      _createSampleData(steps),
      // Disable animations for image tests.
      animate: false,
    );
  }
  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  ShareFilesAndScreenshotWidgets().shareScreenshot(
                      previewContainer,
                      originalSize,
                      "Title",
                      "Name.png",
                      "image/png",
                      text: "This is the my data");
                },
                icon: Icon(
                  Icons.ios_share_rounded,
                  color: colors.white,
                ))
          ],
          backgroundColor: colors.secondary,
          title: Text(
            title,
            style: colors.font6,
          ),
          centerTitle: true,
        ),
        backgroundColor: colors.maincolor,
        body: RepaintBoundary(
            key: previewContainer,
            child: new charts.BarChart(
              seriesList,
              animate: animate,
              barRendererDecorator: new charts.BarLabelDecorator<String>(),
              domainAxis: new charts.OrdinalAxisSpec(),
            )));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData(
      List<double?> steps) {
    final data = [
      new OrdinalSales(
          DateFormat('EE').format(date.subtract(const Duration(days: 6))),
          steps[6]!),
      new OrdinalSales(
          DateFormat('EE').format(date.subtract(const Duration(days: 5))),
          steps[5]!),
      new OrdinalSales(
          DateFormat('EE').format(date.subtract(const Duration(days: 4))),
          steps[4]!),
      new OrdinalSales(
          DateFormat('EE').format(date.subtract(const Duration(days: 3))),
          steps[3]!),
      new OrdinalSales(
          DateFormat('EE').format(date.subtract(const Duration(days: 2))),
          steps[2]!),
      new OrdinalSales(
          DateFormat('EE').format(date.subtract(const Duration(days: 1))),
          steps[1]!),
      new OrdinalSales(
          DateFormat('EE').format(date.subtract(const Duration(days: 0))),
          steps[0]!),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
          id: 'Steps',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (OrdinalSales sales, _) =>
              '${sales.sales.toString()}')
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}
