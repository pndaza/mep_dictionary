import 'package:flutter/material.dart';
import 'package:mep_dictionary/database/database_helper.dart';
import 'package:mep_dictionary/model/definition.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Definition>> _allDefinitions;
  List<Definition> _definitions = List();
  final _textFieldControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textFieldControler.addListener(_filterDefinitions);
    _allDefinitions = loadDefinitions();
  }

  @override
  void dispose() {
    _textFieldControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ဦးဟုတ်စိန် အဘိဓာန်'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: definitionList()),
              _filterView(),
            ],
          ),
        ));
  }

  Widget definitionList() {
    return FutureBuilder(
        future: _allDefinitions,
        builder:
            (BuildContext context, AsyncSnapshot<List<Definition>> snapshot) {
          if (snapshot.hasData) {
            _definitions = List.from(snapshot.data);
            return ListView.separated(
              itemCount: _definitions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _definitions[index].my,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        _definitions[index].eng,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        _definitions[index].pli,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<List<Definition>> loadDefinitions() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    List<Definition> definitions = await databaseHelper.getAllDefinitions();
    return definitions;
  }

  Widget _filterView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _textFieldControler,
        decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(16.0),
              ),
            ),
            filled: true,
            hintStyle: new TextStyle(color: Colors.grey[800]),
            hintText: "Type in your text",
            fillColor: Colors.white70),
      ),
    );
  }

  void _filterDefinitions() {
    String _filterWord = _textFieldControler.text;
    setState(() {
      
    });
  }
}
