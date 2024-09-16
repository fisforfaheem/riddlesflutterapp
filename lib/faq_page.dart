import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.category, color: Colors.blue),
            title: const Text(
              'FAQ 1: What types of jokes are in this app?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FaqDetailPage(
                  title: 'FAQ 1: What types of jokes are in this app?',
                  content:
                      'Our app features a wide variety of jokes, including puns, one-liners, knock-knock jokes, and more. We have jokes suitable for all ages and preferences, from clean family-friendly humor to more adult-oriented jokes.',
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.update, color: Colors.green),
            title: const Text(
              'FAQ 2: How often are new jokes added?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FaqDetailPage(
                  title: 'FAQ 2: How often are new jokes added?',
                  content:
                      'We update our joke database regularly, adding new jokes every week. This ensures that you always have fresh content to enjoy and share with your friends and family.',
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.share, color: Colors.orange),
            title: const Text(
              'FAQ 3: Can I share jokes from the app?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FaqDetailPage(
                  title: 'FAQ 3: Can I share jokes from the app?',
                  content:
                      'Yes, you can easily share jokes from our app. Each joke has a share button that allows you to send it via various platforms like WhatsApp, Facebook, Twitter, or SMS. Spread the laughter with your friends and family!',
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text(
              'FAQ 4: How do I save my favorite jokes?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FaqDetailPage(
                  title: 'FAQ 4: How do I save my favorite jokes?',
                  content:
                      'To save a joke as a favorite, simply tap the heart icon next to the joke. You can access all your favorite jokes in the "Favorites" section of the app. This feature allows you to quickly find and revisit the jokes you love the most.',
                ),
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class FaqDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const FaqDetailPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FaqPage(),
  ));
}
