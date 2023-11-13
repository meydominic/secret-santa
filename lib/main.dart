import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secret_santa/selection_dropdown_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secret Santa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Secret Santa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _names = [];

  TextEditingController nameTextFieldController = TextEditingController();
  late FocusNode nameTextFieldFocusNode;

  @override
  void initState() {
    super.initState();

    nameTextFieldFocusNode = FocusNode(
      onKey: (node, event) {
        if (nameTextFieldController.text.isEmpty &&
            event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          String name = _names.removeLast();
          nameTextFieldController.text = name;
          setState(() {});
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    DataTable(
                        showBottomBorder: true,
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Exclude')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: _buildRows()),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextField(
                        controller: nameTextFieldController,
                        focusNode: nameTextFieldFocusNode,
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a name',
                        ),
                        onSubmitted: (value) {
                          _names.add(value);
                          nameTextFieldController.clear();
                          nameTextFieldFocusNode.requestFocus();
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DataTable(
                        showBottomBorder: true,
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Combination'))
                        ],
                        rows: _buildCombinations()),
                    ElevatedButton(
                      child: const Text('Reroll'),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  List<DataRow> _buildRows() {
    List<DataRow> rows = [];

    for (final (index, name) in _names.indexed) {
      DataRow dataRow = DataRow(cells: [
        DataCell(Text(name)),
        DataCell(DropdownButton<String>(
          items: _buildDropDownList(excludeName: name),
          onChanged: (Object? value) {},
          value: null,
        )),
        DataCell(Row(
          children: [
            // Edit entry
            IconButton(
                onPressed: () {
                  String removedName = _names.removeAt(index);
                  nameTextFieldController.text = removedName;
                  setState(() {});
                },
                icon: const Icon(Icons.edit)),
            // Delete entry
            IconButton(
                onPressed: () {
                  _names.removeAt(index);
                  setState(() {});
                },
                icon: const Icon(Icons.delete)),
          ],
        )),
      ]);

      rows.add(dataRow);
    }

    return rows;
  }

  List<DropdownMenuItem<String>> _buildDropDownList(
      {required String excludeName}) {
    List<DropdownMenuItem<String>> dropDownList = [];

    DropdownMenuItem<String> emptyEntry =
        const DropdownMenuItem(enabled: false, child: SizedBox());

    dropDownList.add(emptyEntry);

    for (String name in _names) {
      if (name == excludeName) {
        continue;
      }
      var selectionDropDownItem = SelectionDropdownItem(name: name);
      dropDownList
          .add(DropdownMenuItem(value: name, child: selectionDropDownItem));
    }

    return dropDownList;
  }

  List<DataRow> _buildCombinations() {
    List<DataRow> combinations = [];

    if (_names.length < 2) {
      return combinations;
    }

    List<String> shuffledNames = List.from(_names);
    shuffledNames.shuffle();

    for (final (index, name) in shuffledNames.indexed) {
      String combination;
      if (index == (shuffledNames.length - 1)) {
        combination = '$name --> ${shuffledNames.first}';
      } else {
        combination = '$name --> ${shuffledNames.elementAt(index + 1)}';
      }

      DataRow dataRow = DataRow(cells: [DataCell(Text(combination))]);
      combinations.add(dataRow);
    }

    return combinations;
  }
}
