import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:learnapi/quote.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Quote> _quoteList = [];

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    final url = Uri.parse("https://gravenquotes.fr/api/list");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // recuperation ok
      final List<dynamic> data = convert.json.decode(response.body);
      setState(() {
        _quoteList = data.map((data) => Quote.fromJson(data)).toList();
      });

      print(data);
    } else {
      // erreur
      print("Failed to load quotes");
    }
  }

  Future<void> addQuote() async {
    final url = Uri.parse("https://gravenquotes.fr/api/add");
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: convert.json.encode({
          'quote': 'Hey bien salut à tous c graven',
          'author': 'GravenDev'
        }));

    if (response.statusCode == 200) {
      print("OK");
      fetchQuote();
    } else {
      print("Erreur");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Citations"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _quoteList.length,
        itemBuilder: (context, index) {
          final Quote quote = _quoteList[index];
          return ListTile(
            title: Text(quote.quote),
            subtitle: Text(quote.author),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addQuote(),
      ),
    );
  }
}
