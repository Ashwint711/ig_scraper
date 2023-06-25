import 'package:flutter/material.dart';

class ProfileStatsItem extends StatelessWidget {
  const ProfileStatsItem(
      {required this.statsCount, required this.statsName, super.key});
  final int statsCount;
  final String statsName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            statsCount.toString(),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            statsName,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}
