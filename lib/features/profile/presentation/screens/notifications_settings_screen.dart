import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool pushEnabled = true;
  bool emailEnabled = false;
  bool goalsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive alerts on your device'),
            value: pushEnabled,
            onChanged: (val) => setState(() => pushEnabled = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Email Summaries'),
            subtitle: const Text('Receive weekly savings reports'),
            value: emailEnabled,
            onChanged: (val) => setState(() => emailEnabled = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Goal Reminders'),
            subtitle: const Text('Get notified when you are close to a goal'),
            value: goalsEnabled,
            onChanged: (val) => setState(() => goalsEnabled = val),
          ),
        ],
      ),
    );
  }
}
