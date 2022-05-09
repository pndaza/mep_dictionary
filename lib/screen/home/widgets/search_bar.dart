import 'package:flutter/material.dart';

enum FilterMode { start, anywhere }

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar(
      {Key? key,
      required this.searchMode,
      required this.onFilterTextChanged,
      required this.onFilterModeChanged})
      : super(key: key);
  final FilterMode searchMode;
  final void Function(String) onFilterTextChanged;
  final void Function(FilterMode) onFilterModeChanged;
  @override
  _SearchFilterBarState createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  late TextEditingController textEditingController = TextEditingController();
  bool hasText = false;
  @override
  void initState() {
    // textEditingController = TextEditingController();
    textEditingController.addListener(() {
      setState(() {
        hasText = textEditingController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      height: 56.0,
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: textEditingController,
            onChanged: (text) {
              widget.onFilterTextChanged(text);
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.transparent,
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              hintStyle: TextStyle(color: Colors.grey),
            ),
          )),
          hasText
              ? ClearButton(onClicked: () {
                  textEditingController.text = '';
                  widget.onFilterTextChanged('');
                })
              : const SizedBox(width: 0, height: 0),
          FilterModeButton(
              searchMode: widget.searchMode,
              onChanged: widget.onFilterModeChanged),
          const SizedBox(width: 8)
        ],
      ),
    );
  }
}

class FilterModeButton extends StatefulWidget {
  const FilterModeButton(
      {Key? key, required this.searchMode, required this.onChanged})
      : super(key: key);
  final FilterMode searchMode;
  final Function(FilterMode) onChanged;

  @override
  _FilterModeButtonState createState() => _FilterModeButtonState();
}

class _FilterModeButtonState extends State<FilterModeButton> {
  bool _previousValue = false;
  @override
  void initState() {
    if (widget.searchMode == FilterMode.start) {
      _previousValue = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: const Text('အစတူ', textScaleFactor: 1.0),
      labelStyle: TextStyle(
          fontSize: 16,
          color: _previousValue == true
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface),
      selectedColor: Theme.of(context).colorScheme.primary,
      checkmarkColor: Theme.of(context).colorScheme.onPrimary,
      selected: _previousValue,
      onSelected: (value) {
        setState(() {
          _previousValue = value;
          if (value) {
            widget.onChanged(FilterMode.start);
          } else {
            widget.onChanged(FilterMode.anywhere);
          }
        });
      },
    );
  }
}

class ClearButton extends StatelessWidget {
  const ClearButton({Key? key, required this.onClicked}) : super(key: key);
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClicked,
      icon: const Icon(Icons.clear_rounded),
    );
  }
}
