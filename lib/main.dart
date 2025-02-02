import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: DiamondManagementScreen(),
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

class DiamondManagementScreen extends StatefulWidget {
  @override
  _DiamondManagementScreenState createState() =>
      _DiamondManagementScreenState();
}

class _DiamondManagementScreenState extends State<DiamondManagementScreen> {
  late DiamondDataSource diamondDataSource;
  List<Diamond> selectedDiamonds = [];
  List<DiamondTransaction> transactions = [];

  @override
  void initState() {
    super.initState();
    diamondDataSource = DiamondDataSource();
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
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  final newDiamond = Diamond(
                    diamondDataSource.diamonds.length + 1,
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

                  diamondDataSource.addDiamond(newDiamond);

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
            child: Text('Add', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }

  void _transferDiamond() {
    if (selectedDiamonds.length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select exactly one diamond to transfer')),
      );
      return;
    }

    final diamond = selectedDiamonds[0];
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

                diamondDataSource.updateDiamond(diamond);
              });
              Navigator.pop(context);
            },
            child: Text('Transfer', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }

  void _viewTransactionHistory() {
    if (selectedDiamonds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a diamond to view its history')),
      );
      return;
    }

    final diamond = selectedDiamonds[0];
    final diamondTransactions = transactions
        .where((t) => t.diamondId == diamond.id)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
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
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _addNewDiamond,
          ),
          IconButton(
            icon: Icon(Icons.transfer_within_a_station, color: Colors.white),
            onPressed: _transferDiamond,
          ),
          IconButton(
            icon: Icon(Icons.history, color: Colors.white),
            onPressed: _viewTransactionHistory,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SfDataGrid(
          source: diamondDataSource,
          selectionMode: SelectionMode.multiple,
          onSelectionChanged: (addedRows, removedRows) {
            setState(() {
              for (var row in removedRows) {
                int id = row.getCells()[0].value;
                selectedDiamonds.removeWhere((diamond) => diamond.id == id);
              }
              for (var row in addedRows) {
                int id = row.getCells()[0].value;
                Diamond? diamond = diamondDataSource.diamonds
                    .firstWhere((diamond) => diamond.id == id);
                if (!selectedDiamonds.contains(diamond)) {
                  selectedDiamonds.add(diamond);
                }
              }
            });
          },
          columns: [
            GridColumn(
              columnName: 'id',
              label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child:
                    Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            GridColumn(
              columnName: 'caratWeight',
              label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text('Carats',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            GridColumn(
              columnName: 'clarity',
              label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text('Clarity',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            GridColumn(
              columnName: 'color',
              label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text('Color',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            GridColumn(
              columnName: 'currentHolder',
              label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text('Current Holder',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            GridColumn(
              columnName: 'receivedDate',
              label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text('Received Date',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            GridColumn(
              columnName: 'status',
              label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text('Status',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            GridColumn(
              columnName: 'price',
              label: Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text('Price',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          // selectionMode: SelectionMode.multiple,
          allowSorting: true,
          allowFiltering: true,
          rowHeight: 50,
          headerRowHeight: 50,
        ),
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
          padding: EdgeInsets.all(8.0),
          child: Text(dataGridCell.value.toString(),
              style: TextStyle(fontSize: 14)),
        );
      }).toList(),
    );
  }
}
