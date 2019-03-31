import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Views/AppBar/BibleBottomNavigationBar.dart';
import 'package:bible_bloc/Views/Notes/NoteTaker.dart';
import 'package:bible_bloc/Views/Notes/NotesIndex.dart';
import 'package:flutter/material.dart';
import 'package:notus/notus.dart';

class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotesIndex(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateNoteDialog(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: new BibleBottomNavigationBar(context: context),
    );
  }

  Future showCreateNoteDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    var text = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController();
        return SimpleDialog(
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidate: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Title",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                    ),
                    RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          Navigator.pop(context, _controller.text);
                        }
                      },
                      child: Text('Submit'),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
    if (text != null) {
      var id =
          await InheritedBlocs.of(context).notesBloc.highestNoteId.first ?? 0;
      id++;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return NotePage(
              note: Note(
                id: id,
                title: text,
                lastUpdated: DateTime.now(),
                doc: NotusDocument(),
              ),
            );
          },
        ),
      );
    }
  }
}
