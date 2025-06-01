import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/quote_model.dart';
import 'providers/quote_provider.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(QuoteModelAdapter());
  await Hive.openBox<QuoteModel>('quotesBox');
  await Hive.openBox('appData');

  await seedQuotes(); // populate quotes once

  runApp(MyApp());
}

Future<void> seedQuotes() async {
  final box = Hive.box<QuoteModel>('quotesBox');
  if (box.isEmpty) {
    final sampleQuotes = [
      QuoteModel(text: "Believe in yourself.", author: "Unknown"),
      QuoteModel(text: "You are stronger than you think.", author: "Anonymous"),
      QuoteModel(text: "Don't stop when you're tired. Stop when you're done.", author: "Unknown"),
    ];
    for (var quote in sampleQuotes) {
      await box.add(quote);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuoteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
