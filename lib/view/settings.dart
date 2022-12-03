import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  static final List<String> _settings = [
    'Start new cut',
    'View previous cut',
    'Edit weights'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 170,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(25)),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _settings.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: Text(
                      _settings[index],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  index == _settings.length - 1 ? SizedBox() : Divider(),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
