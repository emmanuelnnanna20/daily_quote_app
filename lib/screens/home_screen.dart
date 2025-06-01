import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
 @override
Widget build(BuildContext context) {
  final quoteProvider = Provider.of<QuoteProvider>(context);
  final quote = quoteProvider.currentQuote; // quote is QuoteModel?

  return Scaffold(
    appBar: AppBar(
      title: Text("Daily Quote"),
      actions: [
        IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoritesScreen()),
            );
          },
        ),
      ],
    ),
    body: quote == null
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '"${quote.text}"',
                  style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  "- ${quote.author}",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                IconButton(
                  icon: Icon(
                    quote.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: () {
                    quoteProvider.toggleFavorite(quote);
                  },
                )
              ],
            ),
          ),
  );
}
}