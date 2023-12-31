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
  final List<String> _combinations = [];

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
          nameTextFieldFocusNode.requestFocus();
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
        body: OrientationBuilder(builder: (context, orientation) {
          return GridView.count(
            physics: const ScrollPhysics(),
            crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
            children: [
              _buildNameAdministrationBlock(context),
              _buildCombinationsBlock(context),
            ],
          );
        }));
  }

  Widget _buildNameAdministrationBlock(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DataTable(
            showBottomBorder: true,
            columns: const <DataColumn>[
              DataColumn(label: Expanded(child: Text('Name'))),
              DataColumn(label: Expanded(child: Text('Exclude'))),
              DataColumn(label: Expanded(child: Text('Action'))),
            ],
            rows: _buildRows()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 100.0),
          child: TextField(
            controller: nameTextFieldController,
            focusNode: nameTextFieldFocusNode,
            autofocus: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a name',
            ),
            onSubmitted: (value) {
              _onAddNewName(name: value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCombinationsBlock(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _combinations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: index % 2 == 0
                      ? const Color.fromARGB(255, 224, 228, 233)
                      : Colors.white,
                  title: Text(_combinations[index]),
                );
              }),
        ),
        ElevatedButton(
          child: const Text('Reroll'),
          onPressed: () {
            _buildCombinations();
            setState(() {});
          },
        )
      ],
    );
  }

  /// Outsourced function when adding new names.
  void _onAddNewName({required String name}) {
    if (name.trim().isEmpty) {
      return;
    }

    if (_names.contains(name)) {
      // TODO: add error msg or toast
      return;
    }

    _names.add(name);
    _buildCombinations();
    nameTextFieldController.clear();
    nameTextFieldFocusNode.requestFocus();
    setState(() {});
  }

  /// Builds the data table with names.
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
                nameTextFieldFocusNode.requestFocus();
                _buildCombinations();
                setState(() {});
              },
              icon: const Icon(Icons.edit),
              tooltip: 'Edit entry',
            ),
            // Delete entry
            IconButton(
              onPressed: () {
                _names.removeAt(index);
                _buildCombinations();
                setState(() {});
              },
              icon: const Icon(Icons.delete),
              tooltip: 'Delete entry',
            ),
          ],
        )),
      ]);

      rows.add(dataRow);
    }

    return rows;
  }

  /// Builds the drop down widget with names to exclude.
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

  /// Builds the data table with combinations for gifting.
  void _buildCombinations() {
    if (_names.length < 2) {
      return;
    }

    List<String> shuffledNames = List.from(_names);
    shuffledNames.shuffle();

    _combinations.clear();

    for (final (index, name) in shuffledNames.indexed) {
      String combination;
      if (index == (shuffledNames.length - 1)) {
        combination = '$name ⟶ ${shuffledNames.first}';
      } else {
        combination = '$name ⟶ ${shuffledNames.elementAt(index + 1)}';
      }

      _combinations.add(combination);
    }
  }
}
