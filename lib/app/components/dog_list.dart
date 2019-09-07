import 'package:flutter/material.dart';
import 'package:projeto1/app/helpers/SQLiteHelper.dart';
import 'package:projeto1/app/models/dog.dart';


class DogScreen extends StatefulWidget {
  final Dog dog;
  DogScreen(this.dog);

  @override
  State<StatefulWidget> createState() => new _DogScreenState();
}

class _DogScreenState extends State<DogScreen> {
  SQLiteHelper db = new SQLiteHelper();

  TextEditingController _nameController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _nameController = new TextEditingController(text: widget.dog.name);
    _descriptionController = new TextEditingController(text: widget.dog.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  (widget.dog.id != null) ? Text('Edit Pet') : Text('Register Pet'),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: (widget.dog.id != null) ? Text('Update') : Text('Add'),
              onPressed: () {
                if (widget.dog.id != null) {
                  db.updateDog(Dog.fromMap({
                    'id': widget.dog.id,
                    'name': _nameController.text,
                    'description': _descriptionController.text
                  })).then((_) {
                    Navigator.pop(context, 'update');
                  });
                }else {
                  db.saveDog(Dog(_nameController.text, _descriptionController.text)).then((_) {
                    Navigator.pop(context, 'save');
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}