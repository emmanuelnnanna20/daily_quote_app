import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/quote_model.dart';

class QuoteProvider extends ChangeNotifier {
  static const String quotesBoxName = 'quotesBox';
  static const String lastShownDateKey = 'lastShownDate';
  static const String lastQuoteKey = 'lastQuote';

  late Box<QuoteModel> quotesBox;
  QuoteModel? currentQuote;

  QuoteProvider() {
    init();
  }

  Future<void> init() async {
    // Open the Hive box for QuoteModel
    quotesBox = await Hive.openBox<QuoteModel>(quotesBoxName);
    await loadDailyQuote();
  }

  Future<void> loadDailyQuote() async {
    // Box to store app metadata like last shown date and quote key
    final box = await Hive.openBox('appData');
    final lastShownDate = box.get(lastShownDateKey);
    final now = DateTime.now();

    if (lastShownDate == null || DateTime.parse(lastShownDate).day != now.day) {
      currentQuote = _getRandomQuote();
      box.put(lastShownDateKey, now.toIso8601String());
      box.put(lastQuoteKey, currentQuote!.key);
    } else {
      final lastQuoteId = box.get(lastQuoteKey);
      currentQuote = quotesBox.get(lastQuoteId)!;
    }

    notifyListeners();
  }

  QuoteModel _getRandomQuote() {
    final allQuotes = quotesBox.values.toList();
    return allQuotes[Random().nextInt(allQuotes.length)];
  }

  void toggleFavorite(QuoteModel quote) {
    quote.isFavorite = !quote.isFavorite;
    quote.save();
    notifyListeners();
  }

  List<QuoteModel> get favorites =>
      quotesBox.values.cast<QuoteModel>().where((q) => q.isFavorite).toList();
}