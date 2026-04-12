import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isMistakesLimitEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildDarkModeSwitch(context),
            SizedBox(height: 16),
            _buildBarButton(context, 'About', () {
              _showAboutDialog(context);
            }),
            SizedBox(height: 16),
            _buildFeedbackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBarButton(BuildContext context, String text, Function onPressed) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeSwitch(BuildContext context) {
    return InkWell(
      onTap: () {
        AdaptiveTheme.of(context).toggleThemeMode();
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark,
              onChanged: (value) {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMistakesLimitSwitch(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isMistakesLimitEnabled = !isMistakesLimitEnabled;
        });
        // TODO: Implement your logic to control the mistake limit
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor,
        ),
        child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            Switch(
              value: isMistakesLimitEnabled,
              onChanged: (value) {
                setState(() {
                  isMistakesLimitEnabled = value;
                });
                // TODO: Implement your logic to control the mistake limit
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Sudoku App'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Version: 1.0.0'),
                SizedBox(height: 8),
                Text('Developers: Ananto, Dojana, Kashfia'),
                SizedBox(height: 8),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Welcome to the Sudoku App – your ultimate puzzle-solving companion!'
                      '\n\nChallenge your mind with our beautifully crafted Sudoku puzzles. '
                      'Whether you are a beginner or an experienced player, our app offers a wide range of difficulty levels to suit your skills.'
                      '\n\nKey Features:'
                      '\n- Clean and intuitive interface'
                      '\n- Multiple difficulty levels: Easy, Medium, Hard, Expert'
                      '\n- Hints and undo/redo functionality'
                      '\n- Track your statistics and improve your skills'
                      '\n\nEnjoy the timeless classic Sudoku with a modern twist. Happy solving!',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeedbackButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _showFeedbackDialog(context);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Feedback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.mail),
          ],
        ),
      ),
    );
  }

  void _sendFeedbackEmail(String message, List<String> recipientEmails) async {
    final String recipients = recipientEmails.join(',');

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipients,
      query: 'subject=Feedback for Sudoku App&body=Dear developers,\n\n$message',
    );

    try {
      if (await canLaunch(emailLaunchUri.toString())) {
        await launch(emailLaunchUri.toString());
      } else {
        throw 'Could not launch email';
      }
    } catch (e) {
      print('Error launching email: $e');
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    String userMessage = ''; // Variable to store the user's message

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                maxLines: 3,
                onChanged: (value) {
                  userMessage = value;
                },
                decoration: InputDecoration(
                  hintText: 'Write your feedback here...',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _sendFeedbackEmail(userMessage, [
                    'tasmia.cse.20210204038@aust.edu',
                    'abu.cse.20210204039@aust.edu',
                    'ananto.cse.20210204028@aust.edu',
                  ]);
                },
                child: Text('Send'),
              ),
            ],
          ),
        );
      },
    );
  }
}
