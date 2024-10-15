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
          _buildFaqItem(
            context,
            'What types of riddles are in this app?',
            'Our app features a wide variety of riddles, including word puzzles, logic riddles, and brain teasers. We have riddles suitable for all ages and difficulty levels, from easy to challenging.',
          ),
          _buildFaqItem(
            context,
            'How often are new riddles added?',
            'We update our riddle database regularly, adding new riddles every week. This ensures that you always have fresh content to challenge your mind and enjoy with friends and family.',
          ),
          _buildFaqItem(
            context,
            'Can I save my favorite riddles?',
            'Yes! You can easily save your favorite riddles by tapping the heart icon next to each riddle. You can access all your favorite riddles in the "Favorites" section of the app.',
          ),
          _buildFaqItem(
            context,
            'How do I share riddles with friends?',
            'Each riddle has a share button that allows you to send it via various platforms like WhatsApp, Facebook, Twitter, or SMS. Spread the fun and challenge your friends!',
          ),
          _buildFaqItem(
            context,
            'Is there a way to track my progress?',
            'Currently, we don\'t have a progress tracking feature, but we\'re considering adding one in future updates. Stay tuned for new features!',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return ListTile(
      title: Text(
        question,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FaqDetailPage(
            title: question,
            content: answer,
          ),
        ),
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
