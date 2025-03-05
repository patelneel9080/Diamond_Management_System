import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import '../models/diamond.dart';
import '../models/diamond_transaction.dart';
import '../data/diamond_data_source.dart';
import '../services/firebase_services.dart';

class TableInfo {
  String name;
  DiamondDataSource dataSource;
  List<GridColumn> columns;
  List<String> columnNames;
  List<String> columnHeaders;
  List<Diamond> selectedDiamonds = [];

  TableInfo({
    required this.name,
    required this.dataSource,
    required this.columns,
    required this.columnNames,
    required this.columnHeaders,
  });
}

class DiamondManagementScreen extends StatefulWidget {
  @override
  _DiamondManagementScreenState createState() =>
      _DiamondManagementScreenState();
}

class _DiamondManagementScreenState extends State<DiamondManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<TableInfo> tables = [];
  List<DiamondTransaction> transactions = [];
  int tabIndex = 0;
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize Firebase and load data
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Create the default table
    TableInfo defaultTable = await _createDefaultTable();

    setState(() {
      tables.add(defaultTable);
      _isLoading = false;
    });

    // Initialize tab controller
    _tabController = TabController(length: tables.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });
  }

  Future<TableInfo> _createDefaultTable() async {
    // Default column names and headers
    List<String> columnNames = [
      'id', 'caratWeight', 'clarity', 'color', 'currentHolder',
      'receivedDate', 'status', 'price'
    ];

    List<String> columnHeaders = [
      'ID', 'Carats', 'Clarity', 'Color', 'Current Holder',
      'Received Date', 'Status', 'Price'
    ];

    // Create data source
    DiamondDataSource dataSource = DiamondDataSource();
    await dataSource.initializeData();

    // Create columns
    List<GridColumn> columns = _generateColumns(columnNames, columnHeaders);

    return TableInfo(
      name: 'Diamonds',
      dataSource: dataSource,
      columns: columns,
      columnNames: columnNames,
      columnHeaders: columnHeaders,
    );
  }

  List<GridColumn> _generateColumns(List<String> columnNames, List<String> columnHeaders) {
    List<GridColumn> columns = [];

    for (int i = 0; i < columnNames.length; i++) {
      columns.add(
        GridColumn(
          columnName: columnNames[i],
          label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              columnHeaders[i],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return columns;
  }

  void _addNewTable() {
    final nameController = TextEditingController(text: 'New Table ${tables.length + 1}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Table Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              // Create a new data source
              DiamondDataSource dataSource = DiamondDataSource();
              await dataSource.initializeData();

              setState(() {
                // Create a new table with the same structure as the default
                List<String> columnNames = [
                  'id', 'caratWeight', 'clarity', 'color', 'currentHolder',
                  'receivedDate', 'status', 'price'
                ];

                List<String> columnHeaders = [
                  'ID', 'Carats', 'Clarity', 'Color', 'Current Holder',
                  'Received Date', 'Status', 'Price'
                ];

                List<GridColumn> columns = _generateColumns(columnNames, columnHeaders);

                tables.add(TableInfo(
                  name: nameController.text,
                  dataSource: dataSource,
                  columns: columns,
                  columnNames: columnNames,
                  columnHeaders: columnHeaders,
                ));

                // Update tab controller
                _tabController = TabController(
                  length: tables.length,
                  vsync: this,
                  initialIndex: tables.length - 1,
                );

                tabIndex = tables.length - 1;
                _tabController.index = tabIndex;
              });
              Navigator.pop(context);
            },
            child: Text('Create', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }

  void _renameTable() {
    final nameController = TextEditingController(text: tables[tabIndex].name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Table Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                tables[tabIndex].name = nameController.text;
              });
              Navigator.pop(context);
            },
            child: Text('Rename', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }

  void _editColumns() {
    List<TextEditingController> headerControllers = tables[tabIndex].columnHeaders
        .map((header) => TextEditingController(text: header))
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Column Headers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tables[tabIndex].columnHeaders.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextField(
                  controller: headerControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Column ${index + 1} (${tables[tabIndex].columnNames[index]})',
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Update column headers
                for (int i = 0; i < tables[tabIndex].columnHeaders.length; i++) {
                  tables[tabIndex].columnHeaders[i] = headerControllers[i].text;
                }

                // Regenerate columns with new headers
                tables[tabIndex].columns = _generateColumns(
                  tables[tabIndex].columnNames,
                  tables[tabIndex].columnHeaders,
                );
              });
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }

  void _addNewDiamond() {
    final formKey = GlobalKey<FormState>();
    final caratController = TextEditingController();
    final clarityController = TextEditingController();
    final colorController = TextEditingController();
    final receivedFromController = TextEditingController();
    final priceController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Diamond',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: caratController,
                  decoration: InputDecoration(
                      labelText: 'Carat Weight', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter carat weight';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: clarityController,
                  decoration: InputDecoration(
                      labelText: 'Clarity', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter clarity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: colorController,
                  decoration: InputDecoration(
                      labelText: 'Color', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter color';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: receivedFromController,
                  decoration: InputDecoration(
                      labelText: 'Received From', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter source';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                      labelText: 'Price', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: notesController,
                  decoration: InputDecoration(
                      labelText: 'Notes', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // Generate new diamond ID
                int newId = 1;
                if (tables[tabIndex].dataSource.diamonds.isNotEmpty) {
                  newId = tables[tabIndex].dataSource.diamonds
                      .map((d) => d.id)
                      .reduce((a, b) => a > b ? a : b) + 1;
                }

                final newDiamond = Diamond(
                  newId,
                  double.parse(caratController.text),
                  clarityController.text,
                  colorController.text,
                  receivedFromController.text,
                  receivedFromController.text,
                  DateTime.now(),
                  'Available',
                  double.parse(priceController.text),
                  notesController.text,
                );

                // Create transaction
                final transaction = DiamondTransaction(
                  newDiamond.id,
                  DateTime.now(),
                  receivedFromController.text,
                  receivedFromController.text,
                  'Received',
                  'Initial receipt of diamond',
                );

                // Add to Firebase
                await _firebaseService.addTransaction(transaction);
                await tables[tabIndex].dataSource.addDiamond(newDiamond);

                setState(() {
                  transactions.add(transaction);
                });

                Navigator.pop(context);
              }
            },
            child: Text('Add', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }

  void _transferDiamond() async {
    final currentTable = tables[tabIndex];
    if (currentTable.selectedDiamonds.length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select exactly one diamond to transfer')),
      );
      return;
    }

    final diamond = currentTable.selectedDiamonds[0];
    final toPersonController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transfer Diamond',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: toPersonController,
              decoration: InputDecoration(
                  labelText: 'Transfer To', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                  labelText: 'Notes', border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (toPersonController.text.isNotEmpty) {
                final fromPerson = diamond.currentHolder;
                diamond.currentHolder = toPersonController.text;

                // Create transaction
                final transaction = DiamondTransaction(
                  diamond.id,
                  DateTime.now(),
                  fromPerson,
                  toPersonController.text,
                  'Transferred',
                  notesController.text,
                );

                // Add to Firebase and update
                await _firebaseService.addTransaction(transaction);
                await currentTable.dataSource.updateDiamond(diamond);

                setState(() {
                  transactions.add(transaction);
                });

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter recipient name')),
                );
              }
            },
            child: Text('Transfer', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }

  void _viewTransactionHistory() async {
    final currentTable = tables[tabIndex];
    if (currentTable.selectedDiamonds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a diamond to view its history')),
      );
      return;
    }

    final diamond = currentTable.selectedDiamonds[0];

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // Fetch transactions from Firebase
    List<DiamondTransaction> diamondTransactions =
    await _firebaseService.fetchTransactionsForDiamond(diamond.id);
    diamondTransactions.sort((a, b) => b.date.compareTo(a.date));

    // Close loading indicator
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Container(
          width: double.maxFinite,
          child: diamondTransactions.isEmpty
              ? Center(child: Text('No transaction history found'))
              : ListView.builder(
            shrinkWrap: true,
            itemCount: diamondTransactions.length,
            itemBuilder: (context, index) {
              final transaction = diamondTransactions[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(
                      '${transaction.action} - ${DateFormat('yyyy-MM-dd HH:mm').format(transaction.date)}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'From: ${transaction.fromPerson}\nTo: ${transaction.toPerson}\nNotes: ${transaction.notes}'),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diamond Inventory Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 10,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box, color: Colors.white),
            onPressed: _addNewTable,
            tooltip: 'Create New Table',
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: _renameTable,
            tooltip: 'Rename Table',
          ),
          IconButton(
            icon: Icon(Icons.view_column, color: Colors.white),
            onPressed: _editColumns,
            tooltip: 'Edit Column Headers',
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _addNewDiamond,
            tooltip: 'Add Diamond',
          ),
          IconButton(
            icon: Icon(Icons.transfer_within_a_station, color: Colors.white),
            onPressed: _transferDiamond,
            tooltip: 'Transfer Diamond',
          ),
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            onPressed: _viewTransactionHistory,
            tooltip: 'View History',
          ),
        ],
        bottom: _isLoading
            ? PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: LinearProgressIndicator(),
        )
            : TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tables.map((table) => Tab(text: table.name)).toList(),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: tables.map((table) {
          return Container(
            padding: EdgeInsets.all(16),
            child: SfDataGrid(
              source: table.dataSource,
              selectionMode: SelectionMode.multiple,
              onSelectionChanged: (addedRows, removedRows) {
                setState(() {
                  for (var row in removedRows) {
                    int id = row.getCells()[0].value;
                    table.selectedDiamonds.removeWhere((diamond) => diamond.id == id);
                  }
                  for (var row in addedRows) {
                    int id = row.getCells()[0].value;
                    Diamond? diamond = table.dataSource.diamonds
                        .firstWhere((diamond) => diamond.id == id);
                    if (!table.selectedDiamonds.contains(diamond)) {
                      table.selectedDiamonds.add(diamond);
                    }
                  }
                });
              },
              columns: table.columns,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              allowSorting: true,
              allowFiltering: true,
              rowHeight: 50,
              headerRowHeight: 50,
            ),
          );
        }).toList(),
      ),
    );
  }
}