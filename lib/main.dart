import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(          // Add the 3 lines from here...
        primaryColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}

  class _RandomWordsState extends State<RandomWords> {
    final _suggestions = <WordPair>[];
    final _saved = <WordPair>{};
    AudioPlayer audioPlayer = AudioPlayer();

    playLocal() async {
      await audioPlayer.play("assets/tap.mp3", isLocal: true);
    }

    Widget _buildRow(WordPair pair) {
      final alreadySaved = _saved.contains(pair);

      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Lobster",
            color: Colors.white,
          ),
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : Colors.grey,
        ),
        onTap: () {
          playLocal();
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      );
    }

    Widget _buildSuggestions() {
      return ListView.builder(
          padding: const EdgeInsets.all(16),
          // The itemBuilder callback is called once per suggested
          // word pairing, and places each suggestion into a ListTile
          // row. For even rows, the function adds a ListTile row for
          // the word pairing. For odd rows, the function adds a
          // Divider widget to visually separate the entries. Note that
          // the divider may be difficult to see on smaller devices.
          itemBuilder: (BuildContext _context, int i) {
            // Add a one-pixel-high divider widget before each row
            // in the ListView.
            if (i.isOdd) {
              return Divider(color: Colors.grey, thickness: 1.0,);
            }

            // The syntax "i ~/ 2" divides i by 2 and returns an
            // integer result.
            // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
            // This calculates the actual number of word pairings
            // in the ListView,minus the divider widgets.
            final int index = i ~/ 2;
            // If you've reached the end of the available word
            // pairings...
            if (index >= _suggestions.length) {
              // ...then generate 10 more and add them to the
              // suggestions list.
              _suggestions.addAll(generateWordPairs().take(10));
            }
            return _buildRow(_suggestions[index]);
          }
      );
    }

    @override
    Widget build(BuildContext context) {
      void _pushSaved() {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              final Iterable<ListTile> tiles = _saved.map(
                    (WordPair pair) {
                  return ListTile(
                    title: Center(
                      child: Text(
                      pair.asPascalCase,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Lobster",
                        color: Colors.white,
                      ),
                    ),
                    ),
                  );
                },
              );

              final List<Widget> divided = ListTile
                  .divideTiles(
                context: context,
                color: Colors.grey,
                tiles: tiles,
              )
                  .toList();

              return Scaffold(         // Add 6 lines from here...
                appBar: AppBar(
                  title: Text('Saved Suggestions'),
                ),
                backgroundColor: Colors.grey[900],
                body: ListView(children: divided),
              );                       // ... to here.
            },
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText('Startup Name Generator'),
            ],
          ),
          actions: <Widget>[      // Add 3 lines from here...
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          ],                      // ... to here.
        ),
        backgroundColor: Colors.grey[900],
        body: _buildSuggestions(),
      );
    }
  }