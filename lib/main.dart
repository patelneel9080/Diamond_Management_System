import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBiF06hjlU7icFXPn6QBrmKgHmlz8XbNzI",
      authDomain: "diamond-management-322be.firebaseapp.com",
      databaseURL:
          "https://diamond-management-322be-default-rtdb.firebaseio.com",
      projectId: "diamond-management-322be",
      storageBucket: "diamond-management-322be.appspot.com",
      messagingSenderId: "862164183040",
      appId: "1:862164183040:android:062be2358927d813b550e5",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diamond Inventory Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DiamondManagementScreen(),
    );
  }
}

class Diamond {
  Diamond(
    this.id,
    this.caratWeight,
    this.clarity,
    this.color,
    this.currentHolder,
    this.receivedFrom,
    this.receivedDate,
    this.status,
    this.price,
    this.notes,
  );

  final int id;
  double caratWeight;
  String clarity;
  String color;
  String currentHolder;
  String receivedFrom;
  DateTime receivedDate;
  String status; // Available, In Process, Sold
  double price;
  String notes;
}

class DiamondTransaction {
  final int diamondId;
  final DateTime date;
  final String fromPerson;
  final String toPerson;
  final String action; // Received, Transferred, Sold
  final String notes;

  DiamondTransaction(
    this.diamondId,
    this.date,
    this.fromPerson,
    this.toPerson,
    this.action,
    this.notes,
  );
}

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
  const DiamondManagementScreen({super.key});

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

  @override
  void initState() {
    super.initState();

    // Create the default table
    tables.add(_createDefaultTable());

    // Initialize tab controller
    _tabController = TabController(length: tables.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });
  }

  TableInfo _createDefaultTable() {
    // Default column names and headers
    List<String> columnNames = [
      'id',
      'caratWeight',
      'clarity',
      'color',
      'currentHolder',
      'receivedDate',
      'status',
      'price'
    ];

    List<String> columnHeaders = [
      'ID',
      'Carats',
      'Clarity',
      'Color',
      'Current Holder',
      'Received Date',
      'Status',
      'Price'
    ];

    // Create data source
    DiamondDataSource dataSource = DiamondDataSource();

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

  List<GridColumn> _generateColumns(
      List<String> columnNames, List<String> columnHeaders) {
    List<GridColumn> columns = [];

    for (int i = 0; i < columnNames.length; i++) {
      columns.add(
        GridColumn(
          columnName: columnNames[i],
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              columnHeaders[i],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return columns;
  }

  void _addNewTable() {
    final nameController =
        TextEditingController(text: 'New Table ${tables.length + 1}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Table Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Create a new table with the same structure as the default
                List<String> columnNames = [
                  'id',
                  'caratWeight',
                  'clarity',
                  'color',
                  'currentHolder',
                  'receivedDate',
                  'status',
                  'price'
                ];

                List<String> columnHeaders = [
                  'ID',
                  'Carats',
                  'Clarity',
                  'Color',
                  'Current Holder',
                  'Received Date',
                  'Status',
                  'Price'
                ];

                DiamondDataSource dataSource = DiamondDataSource();
                List<GridColumn> columns =
                    _generateColumns(columnNames, columnHeaders);

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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Create', style: TextStyle(color: Colors.white)),
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
        title: const Text('Rename Table',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Table Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                tables[tabIndex].name = nameController.text;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Rename', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editColumns() {
    List<TextEditingController> headerControllers = tables[tabIndex]
        .columnHeaders
        .map((header) => TextEditingController(text: header))
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Column Headers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tables[tabIndex].columnHeaders.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextField(
                  controller: headerControllers[index],
                  decoration: InputDecoration(
                    labelText:
                        'Column ${index + 1} (${tables[tabIndex].columnNames[index]})',
                    border: const OutlineInputBorder(),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Update column headers
                for (int i = 0;
                    i < tables[tabIndex].columnHeaders.length;
                    i++) {
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
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
        title: const Text('Add New Diamond',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: caratController,
                  decoration: const InputDecoration(
                      labelText: 'Carat Weight', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter carat weight';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: clarityController,
                  decoration: const InputDecoration(
                      labelText: 'Clarity', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter clarity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: colorController,
                  decoration: const InputDecoration(
                      labelText: 'Color', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter color';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: receivedFromController,
                  decoration: const InputDecoration(
                      labelText: 'Received From', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter source';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                      labelText: 'Price', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(
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
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                DatabaseReference databaseRef =
                    FirebaseDatabase.instance.ref("diamonds");

                try {
                  await databaseRef.push().set({
                    "Carat Weight": caratController.text,
                    "Clarity": clarityController.text,
                    "Price": priceController.text,
                    "Received From": receivedFromController.text,
                    "Notes": notesController.text,
                  });

                  print("✅ Diamond data successfully added to Firebase!");
                } catch (e) {
                  print("❌ Error adding diamond data: $e");
                }

                setState(() {
                  final currentTable = tables[tabIndex];
                  final newDiamond = Diamond(
                    currentTable.dataSource.diamonds.length + 1,
                    double.parse(caratController.text),
                    clarityController.text,
                    colorController.text,
                    receivedFromController.text,
                    // Initial holder is the source
                    receivedFromController.text,
                    DateTime.now(),
                    'Available',
                    double.parse(priceController.text),
                    notesController.text,
                  );

                  currentTable.dataSource.addDiamond(newDiamond);

                  // Record the transaction
                  transactions.add(DiamondTransaction(
                    newDiamond.id,
                    DateTime.now(),
                    receivedFromController.text,
                    receivedFromController.text,
                    'Received',
                    'Initial receipt of diamond',
                  ));
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _transferDiamond() {
    final currentTable = tables[tabIndex];
    if (currentTable.selectedDiamonds.length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
        title: const Text('Transfer Diamond',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: toPersonController,
              decoration: const InputDecoration(
                  labelText: 'Transfer To', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                  labelText: 'Notes', border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final fromPerson = diamond.currentHolder;
                diamond.currentHolder = toPersonController.text;

                // Record the transaction
                transactions.add(DiamondTransaction(
                  diamond.id,
                  DateTime.now(),
                  fromPerson,
                  toPersonController.text,
                  'Transferred',
                  notesController.text,
                ));

                currentTable.dataSource.updateDiamond(diamond);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child:
                const Text('Transfer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _viewTransactionHistory() {
    final currentTable = tables[tabIndex];
    if (currentTable.selectedDiamonds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a diamond to view its history')),
      );
      return;
    }

    final diamond = currentTable.selectedDiamonds[0];
    final diamondTransactions = transactions
        .where((t) => t.diamondId == diamond.id)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: diamondTransactions.length,
            itemBuilder: (context, index) {
              final transaction = diamondTransactions[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(
                      '${transaction.action} - ${DateFormat('yyyy-MM-dd HH:mm').format(transaction.date)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
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
            child: const Text('Close', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diamond Inventory Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box, color: Colors.white),
            onPressed: _addNewTable,
            tooltip: 'Create New Table',
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _renameTable,
            tooltip: 'Rename Table',
          ),
          IconButton(
            icon: const Icon(Icons.view_column, color: Colors.white),
            onPressed: _editColumns,
            tooltip: 'Edit Column Headers',
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _addNewDiamond,
            tooltip: 'Add Diamond',
          ),
          IconButton(
            icon: const Icon(Icons.transfer_within_a_station,
                color: Colors.white),
            onPressed: _transferDiamond,
            tooltip: 'Transfer Diamond',
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: _viewTransactionHistory,
            tooltip: 'View History',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tables.map((table) => Tab(text: table.name)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tables.map((table) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: SfDataGrid(
              source: table.dataSource,
              selectionMode: SelectionMode.multiple,
              onSelectionChanged: (addedRows, removedRows) {
                setState(() {
                  for (var row in removedRows) {
                    int id = row.getCells()[0].value;
                    table.selectedDiamonds
                        .removeWhere((diamond) => diamond.id == id);
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

class DiamondDataSource extends DataGridSource {
  List<Diamond> diamonds = [];
  List<DataGridRow> _dataGridRows = [];

  DiamondDataSource() {
    diamonds = [
      Diamond(1, 1.5, 'VS1', 'D', 'John', 'Supplier A', DateTime.now(),
          'Available', 15000, 'Premium cut'),
      Diamond(2, 2.0, 'VVS2', 'E', 'Sarah', 'Supplier B', DateTime.now(),
          'In Process', 25000, 'Excellent polish'),
    ];
    _generateDataGridRows();
  }

  void _generateDataGridRows() {
    _dataGridRows = diamonds.map<DataGridRow>((diamond) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: diamond.id),
        DataGridCell<double>(
            columnName: 'caratWeight', value: diamond.caratWeight),
        DataGridCell<String>(columnName: 'clarity', value: diamond.clarity),
        DataGridCell<String>(columnName: 'color', value: diamond.color),
        DataGridCell<String>(
            columnName: 'currentHolder', value: diamond.currentHolder),
        DataGridCell<String>(
            columnName: 'receivedDate',
            value: DateFormat('yyyy-MM-dd').format(diamond.receivedDate)),
        DataGridCell<String>(columnName: 'status', value: diamond.status),
        DataGridCell<String>(
            columnName: 'price',
            value: NumberFormat.currency(symbol: '\$').format(diamond.price)),
      ]);
    }).toList();
  }

  void addDiamond(Diamond diamond) {
    diamonds.add(diamond);
    _generateDataGridRows();
    notifyListeners();
  }

  void updateDiamond(Diamond diamond) {
    final index = diamonds.indexWhere((d) => d.id == diamond.id);
    if (index != -1) {
      diamonds[index] = diamond;
      _generateDataGridRows();
      notifyListeners();
    }
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(dataGridCell.value.toString(),
              style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
    );
  }
}

//   import 'package:flutter/material.dart';
//   import 'package:firebase_core/firebase_core.dart';
//   import 'firebase_options.dart';
// import 'screens/diamond_management_screen.dart';
//
//   void main() async {
//     WidgetsFlutterBinding.ensureInitialized();
//
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     runApp(DiamondInventoryApp());
//   }
//
//   class DiamondInventoryApp extends StatelessWidget {
//     @override
//     Widget build(BuildContext context) {
//       return MaterialApp(
//         title: 'Diamond Inventory',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: DiamondManagementScreen(),
//       );
//     }
//   }