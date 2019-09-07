import 'package:flutter/material.dart';
import 'package:projeto1/app/components/dog_list.dart';
import 'package:projeto1/app/helpers/SQLiteHelper.dart';
import 'package:projeto1/app/models/dog.dart';


class ListViewDog extends StatefulWidget {
  @override
  _ListViewDog createState() => new _ListViewDog();
}

class _ListViewDog extends State<ListViewDog> {
  List<Dog> items = new List();
  SQLiteHelper db = new SQLiteHelper();

  @override
  void initState() {
    super.initState();

    db.getAllDogs().then((dog) {
      setState(() {
        dog.forEach((dog) {
          items.add(Dog.fromMap(dog));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meus Pets',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Meus Pets'),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return
              Dismissible(
                  key: Key(UniqueKey().toString()),
                  onDismissed: (direction) {
                    _deleteDog(context, items[index], index);
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text(items[index].name + " foi deletado!")));
                  },
                  background: Container(color: Colors.red),
              child: ListTile(
                leading: Icon(IconData(0xe91d, fontFamily: 'MaterialIcons')),
                title: Text(
                  '${items[index].name}',
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                subtitle: Text(
                  '${items[index].description}',
                  style: new TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onLongPress: () => _navigateToDog(context, items[index]),
              )
              );

          },

        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewDog(context),
        ),
      ),
    );
  }

  void _deleteDog(BuildContext context, Dog dog, int position) async {
    db.deleteDog(dog.id).then((notes) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToDog(BuildContext context, Dog dog) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DogScreen(dog)),
    );

    if (result == 'update') {
      db.getAllDogs().then((dogs) {
        setState(() {
          items.clear();
          dogs.forEach((dog) {
            items.add(Dog.fromMap(dog));
          });
        });
      });
    }
  }

  void _createNewDog(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DogScreen(Dog('', ''))),
    );

    if (result == 'save') {
      db.getAllDogs().then((dogs) {
        setState(() {
          items.clear();
          dogs.forEach((dog) {
            items.add(Dog.fromMap(dog));
          });
        });
      });
    }
  }
}