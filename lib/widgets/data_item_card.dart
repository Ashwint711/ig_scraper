import 'package:flutter/material.dart';
import 'package:ig_scraper/model/meta_data.dart';
import 'package:ig_scraper/widgets/profile_stats_item.dart';

class DataItemCard extends StatelessWidget {
  const DataItemCard({required this.data, required this.onTap, super.key});
  final IgMetaData data;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        splashColor: Theme.of(context).colorScheme.secondaryContainer,
        child: Card(
          elevation: 4.0,
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Text(
                  data.username,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.fromLTRB(12, 0, 8, 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                          fit: BoxFit.cover, data.profilePictureUrl),
                    ),
                  ),
                  ProfileStatsItem(
                      statsName: 'Media', statsCount: data.mediaCount),
                  ProfileStatsItem(
                      statsName: 'Followers', statsCount: data.followersCount),
                  ProfileStatsItem(
                      statsName: 'Following', statsCount: data.followsCount),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
