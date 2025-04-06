import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class RandomQuoteGenerate
{
  final List<String> defaultQuotes = [
    "Success is not the key to happiness. Happiness is the key to success.",
    "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.",
    "The harder you work for something, the greater you’ll feel when you achieve it.",
    "Don’t stop when you’re tired. Stop when you’re done.",
    "Dream it. Wish it. Do it.",
    "Success doesn’t come from what you do occasionally. It comes from what you do consistently.",
    "Your limitation—it’s only your imagination.",
    "Great things never come from comfort zones.",
    "It’s not whether you get knocked down, it’s whether you get up.",
    "Push yourself, because no one else is going to do it for you.",
  ];

  Future<Map<String, String>> getQuote() async
  {
    final response = await http.get(Uri.parse('https://qapi.vercel.app/api/quotes'));
    Map<String, String> _quote= {};
    if(response.statusCode==200)
    {
      final data = jsonDecode(response.body);
      final random = Random();
      final randomIndex = random.nextInt(data.length);
      final quoteData = data[randomIndex];

      _quote['quote'] = quoteData['quote'];
      _quote['author'] = quoteData['author'];
    }
    else
    {
      final random = Random();
      int index = random.nextInt(10);

      _quote['quote'] = this.defaultQuotes[index];
      _quote['author'] = 'Unknown';
    }
    return _quote;
  }
}