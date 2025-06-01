import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final favorites = quoteProvider.favorites;

    return Scaffold(
      appBar: AppBar(title: Text("Favorite Quotes")),
      body: favorites.isEmpty
          ? Center(child: Text("No favorites yet."))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (_, index) {
                final quote = favorites[index];
                return ListTile(
                  title: Text('"${quote.text}"'),
                  subtitle: Text("- ${quote.author}"),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      quoteProvider.toggleFavorite(quote);
                    },
                  ),
                );
              },
            ),
    );
  }
}
