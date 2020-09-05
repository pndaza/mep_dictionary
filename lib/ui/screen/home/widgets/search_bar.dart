import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final void Function(String, bool) onChanged;
  final bool searchAtStart;
  final String hint;
  SearchBar(
      {@required this.onChanged,
      this.searchAtStart = false,
      this.hint = 'ရှာလိုရာ စကားလုံး ရိုက်ပါ'});

  @override
  _SearchBarState createState() =>
      _SearchBarState(onChanged, searchAtStart, hint);
}

class _SearchBarState extends State<SearchBar> {
  _SearchBarState(this.onChanged, this.searchAtStart, this.hint);

  final void Function(String, bool) onChanged;
  bool searchAtStart;
  final String hint;
  bool _showClearButton = false;

  Color borderColor = Colors.grey;
  Color textColor = Colors.grey[350];
  TextDecoration textDecoration = TextDecoration.lineThrough;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        _showClearButton = controller.text.length > 0;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(color: Colors.grey),
      ),
      height: 56.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (text) => onChanged(text, searchAtStart),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: clearButton(),
                  hintStyle: new TextStyle(color: Colors.grey),
                  hintText: hint,
                  fillColor: Colors.white70),
            ),
          ),
          searchFilterButton(),
          SizedBox(
            width: 4.0,
          )
        ],
      ),
    );
  }

  Widget clearButton() {
    if (!_showClearButton) {
      return null;
    }
    return IconButton(
      onPressed: () {
        controller.clear();
        onChanged(controller.text, searchAtStart);
      },
      icon: Icon(
        Icons.clear,
        color: Colors.grey,
      ),
    );
  }

  Widget searchFilterButton() {
    return Container(
        width: 48.0,
        height: 48.0,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
              side: BorderSide(color: borderColor)),
          child: Text(
            'အစတူ',
            style: TextStyle(
                fontSize: 12.0, color: textColor, decoration: textDecoration),
          ),
          padding: EdgeInsets.zero,
          onPressed: () {
            setState(() {
              if (searchAtStart == false) {
                borderColor = Colors.blueAccent;
                textColor = Colors.blueAccent;
                textDecoration = TextDecoration.none;
              } else {
                borderColor = Colors.grey;
                textColor = Colors.grey;
                textDecoration = TextDecoration.lineThrough;
              }
              searchAtStart = !searchAtStart;
              onChanged(controller.text, searchAtStart);
            });
          },
        ));
  }
}
