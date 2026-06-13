import 'package:flutter/material.dart';

class LegalTextScreen extends StatelessWidget {
  final String title;

  const LegalTextScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Last Updated: ${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _getDummyText(),
              style: const TextStyle(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  String _getDummyText() {
    return '''
Welcome to our application. Please read these terms carefully.

1. Acceptance of Terms
By accessing or using our application, you agree to be bound by these terms. If you do not agree to all the terms and conditions, then you may not access the application or use any services.

2. User Accounts
When you create an account with us, you must provide us information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the terms, which may result in immediate termination of your account on our Service.

3. Intellectual Property
The Service and its original content, features and functionality are and will remain the exclusive property of our company and its licensors.

4. Links To Other Web Sites
Our Service may contain links to third-party web sites or services that are not owned or controlled by us. We have no control over, and assume no responsibility for, the content, privacy policies, or practices of any third party web sites or services.

5. Termination
We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.

6. Changes
We reserve the right, at our sole discretion, to modify or replace these Terms at any time.

Contact Us
If you have any questions about these Terms, please contact us.
    ''';
  }
}
