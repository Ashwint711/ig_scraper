// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ig_scraper/screens/display_account_details.dart';
import 'package:ig_scraper/model/meta_data.dart';
import 'package:ig_scraper/widgets/data_item_card.dart';
import 'package:ig_scraper/widgets/token_and_id_input.dart';

// My Globals
String? accessToken;
String? igUserId;

class GetAccessToken extends StatefulWidget {
  const GetAccessToken({super.key});
  @override
  State<GetAccessToken> createState() => _GetAccessTokenState();
}

class _GetAccessTokenState extends State<GetAccessToken> {
  var _isLoading = true;
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    try {
      final url = Uri.https(
          'ig-scraper-966a5-default-rtdb.firebaseio.com', 'meta-data.json');
      final response = await http.get(url);
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      // print('loading data -- $data');
      for (final item in data.entries) {
        String username = item.value['username'];
        int followersCount = item.value['followersCount'];
        int followsCount = item.value['followsCount'];
        int mediaCount = item.value['mediaCount'];
        int totalLikes = item.value['totalLikes'];
        String profilePictureUrl = item.value['profilePictureUrl'];
        String biography = item.value['biography'];
        String name = item.value['name'];

        setState(() {
          _metaDataList.add(
            IgMetaData(
              username: username,
              followersCount: followersCount,
              followsCount: followsCount,
              mediaCount: mediaCount,
              totalLikes: totalLikes,
              profilePictureUrl: profilePictureUrl,
              name: name,
              biography: biography,
            ),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      print('There is not existing data');
    }
    // return data;
  }

  final _accessTokenController = TextEditingController();
  final _userIdController = TextEditingController();

  void fetchInstagramMetaData(BuildContext context) async {
    // Replace with your Instagram User ID and access token
    accessToken = _accessTokenController.text;
    igUserId = _userIdController.text;
    final apiUrl = Uri.parse(
        'https://graph.facebook.com/v17.0/$igUserId?fields=followers_count,follows_count,media_count,username,profile_picture_url,name,biography&access_token=$accessToken');

    final dynamic data;
    final int followersCount;
    final int followsCount;
    final int mediaCount;
    final String username;
    final String profilePictureUrl;
    final int totalLikes;
    final String name;
    final String biography;

    try {
      // Fetching data from FACEBOOK API
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        if (!context.mounted) return;
        FocusScope.of(context).unfocus();

        data = jsonDecode(response.body);
        followersCount = data['followers_count'];
        followsCount = data['follows_count'];
        mediaCount = data['media_count'];
        username = data['username'];
        profilePictureUrl = data['profile_picture_url'];
        name = data['name'];
        biography = data['biography'];

        totalLikes = await getTotalLikes(igUserId, accessToken);

        //*POSTING DATA TO FIREBASE*//
        try {
          final url = Uri.https(
              'ig-scraper-966a5-default-rtdb.firebaseio.com', 'meta-data.json');
          http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(
              {
                'followersCount': followersCount,
                'followsCount': followsCount,
                'mediaCount': mediaCount,
                'username': username,
                'profilePictureUrl': profilePictureUrl,
                'name': name,
                'biography': biography,
                'totalLikes': totalLikes,
                'accessToken': accessToken,
                'userId': igUserId,
              },
            ),
          );
        } catch (e) {
          print('Failed to upload data $e');
        }
        // Adding data object to IgMetaData list
        addNewData(
          IgMetaData(
            username: username,
            followersCount: followersCount,
            followsCount: followsCount,
            mediaCount: mediaCount,
            totalLikes: totalLikes,
            profilePictureUrl: profilePictureUrl,
            name: name,
            biography: biography,
          ),
        );
      } else {
        print(
            'Failed to fetch Instagram metadata. Status code: ${response.statusCode}');
        if (!context.mounted) {
          // If context is changed then return from here
          return;
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load meta data'),
          ),
        );
      }
    } catch (e) {
      print('Error occurred while fetching Instagram metadata: $e');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load meta data'),
        ),
      );
    }
  }

  Future<int> getTotalLikes(String? igUserId, String? accessToken) async {
    final apiUrl = Uri.parse(
        'https://graph.facebook.com/v17.0/$igUserId/media?fields=like_count&access_token=$accessToken');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final mediaData = data['data'];
        int totalLikes = 0;

        for (final media in mediaData) {
          final likeCount = media['like_count'];
          totalLikes += likeCount as int;
        }

        return totalLikes;
      } else {
        print(
            'Failed to fetch total likes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching total likes: $e');
    }

    return 0; // Return a default value if fetching fails
  }

  void addNewData(IgMetaData data) {
    setState(() {
      _metaDataList.add(data);
    });
  }

  final List<IgMetaData> _metaDataList = [];

  void _navigateToAccountDetails(IgMetaData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => DisplayAccountDetails(data: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget metaDataList = Expanded(
      child: ListView.builder(
        itemCount: _metaDataList.length,
        itemBuilder: (ctx, index) => DataItemCard(
          data: _metaDataList[index],
          onTap: () {
            _navigateToAccountDetails(_metaDataList[index]);
          },
        ),
      ),
    );
    if (_metaDataList.isEmpty) {
      metaDataList = const Expanded(
        child: Center(
          child: Text('Start Scrapng Meta Data'),
        ),
      );
    }
    if (_isLoading) {
      metaDataList = const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram MetaData Extractor'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Column(
        children: [
          TokenInput(
            accessTokenController: _accessTokenController,
            userIdController: _userIdController,
            fetchInstagramMetaData: () {
              fetchInstagramMetaData(context);
            },
          ),
          metaDataList,
        ],
      ),
    );
  }
}
