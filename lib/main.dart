import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const RiddleApp());
}

class RiddleApp extends StatelessWidget {
  const RiddleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adult Riddles',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const RiddleHomePage(),
    );
  }
}

class RiddleHomePage extends StatefulWidget {
  const RiddleHomePage({super.key});

  @override
  _RiddleHomePageState createState() => _RiddleHomePageState();
}

class _RiddleHomePageState extends State<RiddleHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text('Adult Riddles'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.withOpacity(0.8),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value * 2 * pi,
                    child: Icon(
                      Icons.psychology,
                      size: 100 + (_animation.value * 20),
                      color: Colors.white.withOpacity(0.8),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RiddlePage()),
                  );
                },
                child: const Text('Start Riddles'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RiddlePage extends StatefulWidget {
  const RiddlePage({super.key});

  @override
  _RiddlePageState createState() => _RiddlePageState();
}

class _RiddlePageState extends State<RiddlePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showAnswer = false;
  int _currentRiddleIndex = 0;

  final List<Map<String, String>> _riddles = [
    {
      'question':
          'I have a head and a tail that will never meet. Having too many of me is always a treat. What am I?',
      'answer': 'A coin',
    },
    {
      'question':
          'I have cities, but no houses. I have mountains, but no trees. I have water, but no fish. What am I?',
      'answer': 'A map',
    },
    {
      'question':
          'I have cities, but no houses. I have mountains, but no trees. I have water, but no fish. What am I?',
      'answer': 'A map',
    },
    // Add more riddles here
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
    if (_showAnswer) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _nextRiddle() {
    setState(() {
      _currentRiddleIndex = (_currentRiddleIndex + 1) % _riddles.length;
      _showAnswer = false;
    });
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text('Riddle'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.withOpacity(0.8),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _riddles[_currentRiddleIndex]['question']!,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _toggleAnswer,
                  child: Text(_showAnswer ? 'Hide Answer' : 'Show Answer'),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - _animation.value)),
                        child: Text(
                          _riddles[_currentRiddleIndex]['answer']!,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white70),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _nextRiddle,
                  child: const Text('Next Riddle'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        // title: const Text('About'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.withOpacity(0.8),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adult Riddles',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Version: 1.0.0',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Adult Riddles is a fun and challenging app designed to entertain and stimulate your mind with clever wordplay and thought-provoking questions.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '© 2024 Faheem aal rights reserved.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.withOpacity(0.8),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: const [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our Adult Riddles app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '1. Information Collection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We do not collect any personal information from users of the Adult Riddles app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2. Use of Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'As we do not collect any personal information, we do not use or share any user data.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '3. Changes to This Policy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '4. Contact Us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'If you have any questions about this Privacy Policy, please contact us at privacy@yourcompany.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.withOpacity(0.8),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Rate App'),
              onTap: () {
                // launchUrl(Uri.parse(
                //     'https://play.google.com/store/apps/details?id=your.app.id'));
              },
            ),
            ListTile(
              title: const Text('Share App'),
              onTap: () {
                // Add your app's sharing logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
