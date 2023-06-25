import 'package:flutter/material.dart';

class TokenInput extends StatelessWidget {
  const TokenInput({
    required this.accessTokenController,
    required this.userIdController,
    required this.fetchInstagramMetaData,
    super.key,
  });
  final TextEditingController accessTokenController;
  final TextEditingController userIdController;
  final void Function() fetchInstagramMetaData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      // height: 300,
      // width: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            Theme.of(context).colorScheme.primaryContainer
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: TextField(
            controller: accessTokenController,
            decoration: const InputDecoration(hintText: ' Access Token'),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: TextField(
            controller: userIdController,
            decoration: const InputDecoration(hintText: ' User Id'),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            onPressed: fetchInstagramMetaData,
            child: Text(
              'Get Meta Data',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ),
      ]),
    );
  }
}
