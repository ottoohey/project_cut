import 'package:flutter/material.dart';

class NeumorphicCard extends StatelessWidget {
  const NeumorphicCard(
      {Key? key,
      required this.title,
      required this.value,
      required this.amount})
      : super(key: key);

  final String title;
  final String value;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).splashColor,
            offset: const Offset(-1, -1),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Theme.of(context).shadowColor,
            offset: const Offset(3, 3),
            blurRadius: 5,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: amount,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              textHeightBehavior:
                  const TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
    // child: Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       FittedBox(
    //         fit: BoxFit.contain,
    //         child: Text(
    //           title,
    //           style: TextStyle(
    //             color: Theme.of(context).primaryColor,
    //             fontSize: 16,
    //           ),
    //         ),
    //       ),
    //       Row(
    //         children: [
    //           FittedBox(
    //             fit: BoxFit.fitWidth,
    //             child: Text(
    //               value,
    //               style: TextStyle(
    //                 color: Theme.of(context).primaryColor,
    //                 fontSize: 50,
    //               ),
    //             ),
    //           ),
    //           FittedBox(
    //             fit: BoxFit.fitWidth,
    //             child: Text(
    //               amount,
    //               style: TextStyle(
    //                 color: Theme.of(context).primaryColor,
    //                 fontSize: 20,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // ),
    // );
  }
}

class WeeksRemainingIndicator extends StatefulWidget {
  const WeeksRemainingIndicator({Key? key}) : super(key: key);

  @override
  State<WeeksRemainingIndicator> createState() =>
      _WeeksRemainingIndicatorState();
}

class _WeeksRemainingIndicatorState extends State<WeeksRemainingIndicator> {
  final DateTime currentDate = DateTime.now();
  final DateTime startDate = DateTime.utc(2022, 09, 01);
  final DateTime endDate = DateTime.utc(2022, 12, 25);

  late int progress = (currentDate.difference(startDate).inDays / 7).ceil();
  late int remaining = (endDate.difference(currentDate).inDays / 7).ceil();
  late int total = progress + remaining;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: progress.toDouble(),
          max: total.toDouble(),
          divisions: total.toInt(),
          label: progress.round().toString(),
          activeColor: Theme.of(context).colorScheme.onPrimary,
          inactiveColor:
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
          thumbColor: Theme.of(context).colorScheme.onPrimary,
          onChanged: (double value) {
            setState(() {
              progress = value.toInt();
              remaining = total - progress;
            });
          },
        ),
        Text(
          '$remaining WEEKS REMAINING',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        )
      ],
    );
  }
}
