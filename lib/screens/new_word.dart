import 'package:flutter/material.dart';
import 'package:my_dict/models/db.dart';
import 'package:my_dict/models/word.model.dart';

class NewWordScreen extends StatelessWidget {
  String word = '';
  String meaning = '';
  DBConnect dbConnect;
  NewWordScreen(this.dbConnect, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Word'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(hintText: 'Enter Word'),
                onChanged: (String value) {
                  word = value;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Enter Meaning'),
                onChanged: (String value) {
                  meaning = value;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      dbConnect
                          .insertWord(Word(word: word, meaning: meaning))
                          .then((value) {
                        Navigator.pop(context, word);
                      });
                    }
                  },
                  child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
