import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: RandomWords(),
      theme: ThemeData(
        primaryColor: Colors.white
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = Set<WordPair>();

  Widget _buildRow(WordPair words) {
    final bool alreadySaved = _saved.contains(words);
    return ListTile(
      title: Text(words.asPascalCase, style: _biggerFont),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(words);
          } else {
            _saved.add(words);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved,)
        ],),
        body: _buildSuggestions());
  }

  void _pushSaved(){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context){
        final titles = _saved.map((wordPair){
          return ListTile(
            title: Text(
              wordPair.asPascalCase,
              style: _biggerFont,
            ),
          );
        });
        final divided = ListTile.divideTiles(
          context: context,
          tiles: titles
        ).toList();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Suggestions'),
          ),
          body: ListView(children: divided)
        );
      }
    ));
  }

}
