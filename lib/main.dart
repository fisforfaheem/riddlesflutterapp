import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riddles_app/faq_page.dart';
import 'dart:math';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool showOnboarding = prefs.getBool('showOnboarding') ?? true;
  runApp(RiddleApp(showOnboarding: showOnboarding));
}

class RiddleApp extends StatelessWidget {
  final bool showOnboarding;

  const RiddleApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Riddles',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
          primary: Colors.deepOrange,
          secondary: Colors.deepPurple,
        ),
      ),
      home: showOnboarding ? const OnboardingScreen() : const SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const RiddleHomePage(),
    const RiddlePage(),
    const FavoritesPage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.surface,
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        index: _currentIndex,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.psychology, size: 30),
          Icon(Icons.favorite, size: 30),
          Icon(Icons.more_horiz, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.lightbulb,
      'title': 'Welcome to My Riddles',
      'description': 'Get ready to challenge your mind with clever riddles!',
    },
    {
      'icon': Icons.psychology,
      'title': 'Brain Teasers',
      'description': 'Solve intriguing puzzles and expand your thinking.',
    },
    {
      'icon': Icons.emoji_events,
      'title': 'Have Fun',
      'description': 'Enjoy a collection of witty and entertaining riddles.',
    },
  ];

  void _finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepOrange.withOpacity(0.8),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    icon: _pages[index]['icon'],
                    title: _pages[index]['title'],
                    description: _pages[index]['description'],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text('Skip'),
                  ),
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                        _currentPage == _pages.length - 1 ? 'Start' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.white),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: FadeTransition(
            opacity: _animation,
            child: const Icon(
              Icons.psychology,
              size: 150,
              color: Colors.white,
            ),
          ),
        ),
      ),
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
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
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
        title: const Text('My Riddles'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const SettingsPage()),
          //     );
          //   },
          // ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.withOpacity(0.8),
              Colors.deepOrange.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Colors.amber, Colors.deepOrange],
                  ).createShader(bounds);
                },
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value * 0.1,
                      child: const Icon(
                        Icons.lightbulb,
                        size: 120,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Ready to Challenge Your Mind?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RiddlePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Start Riddles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
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
  Set<int> _favoriteRiddles = {};

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
      'question': 'What has keys but can\'t open locks?',
      'answer': 'A piano',
    },
    {
      'question': 'What has a heart that doesn\'t beat?',
      'answer': 'An artichoke',
    },
    {
      'question':
          'What comes once in a minute, twice in a moment, but never in a thousand years?',
      'answer': 'The letter M',
    },
    {
      'question': 'What has a neck but no head?',
      'answer': 'A bottle',
    },
    {
      'question': 'What can travel around the world while staying in a corner?',
      'answer': 'A stamp',
    },
    {
      'question': 'What has an eye but cannot see?',
      'answer': 'A needle',
    },
    {
      'question': 'What gets wetter as it dries?',
      'answer': 'A towel',
    },
    {
      'question': 'What has a thumb and four fingers but is not alive?',
      'answer': 'A glove',
    },
    {
      'question': 'What has to be broken before you can use it?',
      'answer': 'An egg',
    },
    {
      'question': 'What has a bed but never sleeps?',
      'answer': 'A river',
    },
    {
      'question': 'What has a head, a tail, is brown, and has no legs?',
      'answer': 'A penny',
    },
    {
      'question': 'What has many keys but can\'t open a single lock?',
      'answer': 'A keyboard',
    },
    {
      'question': 'What has hands but can\'t clap?',
      'answer': 'A clock',
    },
    {
      'question': 'What has one eye but can\'t see?',
      'answer': 'A needle',
    },
    {
      'question': 'What has a ring but no finger?',
      'answer': 'A telephone',
    },
    {
      'question': 'What has a face and two hands but no arms or legs?',
      'answer': 'A clock',
    },
    {
      'question': 'What has a bottom at the top?',
      'answer': 'A leg',
    },
    {
      'question': 'What has teeth but can\'t bite?',
      'answer': 'A comb',
    },
    {
      'question': 'What has words but never speaks?',
      'answer': 'A book',
    },
    {
      'question': 'What has a spine but no bones?',
      'answer': 'A book',
    },
    {
      'question': 'What has a bark but no bite?',
      'answer': 'A tree',
    },
    {
      'question': 'What has a foot but no legs?',
      'answer': 'A ruler',
    },
    {
      'question': 'What has a face but no eyes, nose, or mouth?',
      'answer': 'A clock',
    },
    {
      'question': 'What has a head, a tail, is brown, and has no legs?',
      'answer': 'A penny',
    },
    {
      'question': 'What has a ring but no finger?',
      'answer': 'A telephone',
    },
    {
      'question': 'What has a bed but never sleeps?',
      'answer': 'A river',
    },
    {
      'question': 'What has a neck but no head?',
      'answer': 'A bottle',
    },
    {
      'question': 'What has a heart that doesn\'t beat?',
      'answer': 'An artichoke',
    },
    {
      'question': 'What has keys but can\'t open locks?',
      'answer': 'A piano',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRiddles =
          prefs.getStringList('favoriteRiddles')?.map(int.parse).toSet() ?? {};
    });
  }

  void _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteRiddles.contains(_currentRiddleIndex)) {
        _favoriteRiddles.remove(_currentRiddleIndex);
      } else {
        _favoriteRiddles.add(_currentRiddleIndex);
      }
    });
    await prefs.setStringList(
        'favoriteRiddles', _favoriteRiddles.map((e) => e.toString()).toList());
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
        backgroundColor: Colors.white,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _toggleAnswer,
                      child: Text(_showAnswer ? 'Hide Answer' : 'Show Answer'),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: Icon(
                        _favoriteRiddles.contains(_currentRiddleIndex)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
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

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // title: const Text('More Options'),
              background: Image.asset(
                'assets/images/playstore.png',
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildCard(
                context,
                icon: Icons.info,
                title: 'About',
                subtitle: 'Learn more about this app',
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                ),
              ),
              _buildCard(
                context,
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                color: Colors.green,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                ),
              ),
              _buildCard(
                context,
                icon: Icons.share,
                title: 'Share',
                subtitle: 'Share this app',
                color: Colors.orange,
                onTap: () {
                  Share.share(
                    'Download My Riddles app from Playstore: https://play.google.com/store/apps/details?id=com.example.my_riddles',
                  );
                },
              ),
              _buildCard(
                context,
                icon: Icons.star,
                title: 'Rate Us',
                subtitle: 'Rate us on Playstore',
                color: Colors.red,
                onTap: () => launchUrlString(
                  'https://play.google.com/store/apps/details?id=com.example.my_riddles',
                ),
              ),
              _buildCard(
                context,
                icon: Icons.question_answer,
                title: 'FAQs',
                subtitle: 'Frequently asked questions',
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FaqPage()),
                  );
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
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
      appBar: AppBar(title: const Text('About')),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Riddles',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.psychology, size: 40, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Challenge your mind with clever and entertaining riddles.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.lightbulb, size: 40, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Expand your thinking and problem-solving skills.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.emoji_events, size: 40, color: Colors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Have fun while exercising your brain.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('Wide variety of riddles'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('Difficulty levels for all users'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('Regular updates with new riddles'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('User-friendly interface'),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We are a team of riddle enthusiasts dedicated to bringing you the best brain teasers and mind-bending puzzles. Our goal is to entertain and challenge you while helping you improve your cognitive skills.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage({super.key});

  String url = 'https://www.example.com/privacy-policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: WebViewWidget(
          controller: WebViewController()
            ..loadRequest(Uri.parse(url))
            ..setJavaScriptMode(JavaScriptMode.unrestricted)),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Set<int> _favoriteRiddles = {};
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
      'question': 'What has keys but can\'t open locks?',
      'answer': 'A piano',
    },
    {
      'question': 'What has a heart that doesn\'t beat?',
      'answer': 'An artichoke',
    },
    {
      'question':
          'What comes once in a minute, twice in a moment, but never in a thousand years?',
      'answer': 'The letter M',
    },
    {
      'question': 'What has a neck but no head?',
      'answer': 'A bottle',
    },
    {
      'question': 'What can travel around the world while staying in a corner?',
      'answer': 'A stamp',
    },
    {
      'question': 'What has an eye but cannot see?',
      'answer': 'A needle',
    },
    {
      'question': 'What gets wetter as it dries?',
      'answer': 'A towel',
    },
    {
      'question': 'What has a thumb and four fingers but is not alive?',
      'answer': 'A glove',
    },
    {
      'question': 'What has to be broken before you can use it?',
      'answer': 'An egg',
    },
    {
      'question': 'What has a bed but never sleeps?',
      'answer': 'A river',
    },
    {
      'question': 'What has a head, a tail, is brown, and has no legs?',
      'answer': 'A penny',
    },
    {
      'question': 'What has many keys but can\'t open a single lock?',
      'answer': 'A keyboard',
    },
    {
      'question': 'What has hands but can\'t clap?',
      'answer': 'A clock',
    },
    {
      'question': 'What has one eye but can\'t see?',
      'answer': 'A needle',
    },
    {
      'question': 'What has a ring but no finger?',
      'answer': 'A telephone',
    },
    {
      'question': 'What has a face and two hands but no arms or legs?',
      'answer': 'A clock',
    },
    {
      'question': 'What has a bottom at the top?',
      'answer': 'A leg',
    },
    {
      'question': 'What has teeth but can\'t bite?',
      'answer': 'A comb',
    },
    {
      'question': 'What has words but never speaks?',
      'answer': 'A book',
    },
    {
      'question': 'What has a spine but no bones?',
      'answer': 'A book',
    },
    {
      'question': 'What has a bark but no bite?',
      'answer': 'A tree',
    },
    {
      'question': 'What has a foot but no legs?',
      'answer': 'A ruler',
    },
    {
      'question': 'What has a face but no eyes, nose, or mouth?',
      'answer': 'A clock',
    },
    {
      'question': 'What has a head, a tail, is brown, and has no legs?',
      'answer': 'A penny',
    },
    {
      'question': 'What has a ring but no finger?',
      'answer': 'A telephone',
    },
    {
      'question': 'What has a bed but never sleeps?',
      'answer': 'A river',
    },
    {
      'question': 'What has a neck but no head?',
      'answer': 'A bottle',
    },
    {
      'question': 'What has a heart that doesn\'t beat?',
      'answer': 'An artichoke',
    },
    {
      'question': 'What has keys but can\'t open locks?',
      'answer': 'A piano',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRiddles =
          prefs.getStringList('favoriteRiddles')?.map(int.parse).toSet() ?? {};
    });
  }

  void _removeFavorite(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRiddles.remove(index);
    });
    await prefs.setStringList(
        'favoriteRiddles', _favoriteRiddles.map((e) => e.toString()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Riddles'),
        backgroundColor: Colors.white,
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
        child: _favoriteRiddles.isEmpty
            ? const Center(
                child: Text(
                  'No favorite riddles yet!',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: _favoriteRiddles.length,
                itemBuilder: (context, index) {
                  int riddleIndex = _favoriteRiddles.elementAt(index);
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.white.withOpacity(0.1),
                    child: ListTile(
                      title: Text(
                        _riddles[riddleIndex]['question']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        _riddles[riddleIndex]['answer']!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () => _removeFavorite(riddleIndex),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
