import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_lister/screens/update_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_lister/screens/add_screen.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final Box movieBox;

  // Delete info from movie box
  _deleteInfo(int index) {
    movieBox.deleteAt(index);

    print('Item deleted from box at index: $index');
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    movieBox = Hive.box('movieBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Info'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddScreen(),
          ),
        ),
        child: Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: movieBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty) {
            return Center(
              child: Text('Empty'),
            );
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                var currentBox = box;
                var movieData = currentBox.getAt(index)!;

                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateScreen(
                        index: index,
                        movie: movieData,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(movieData.name),
                    subtitle: Text(movieData.director),
                    trailing: IconButton(
                      onPressed: () => _deleteInfo(index),
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}