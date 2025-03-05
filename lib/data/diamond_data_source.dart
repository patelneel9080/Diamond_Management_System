import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import '../models/diamond.dart';
import '../models/diamond_transaction.dart';
import '../services/firebase_services.dart';

class DiamondDataSource extends DataGridSource {
  List<Diamond> diamonds = [];
  List<DataGridRow> _dataGridRows = [];
  final FirebaseService _firebaseService = FirebaseService();
  bool _isInitialized = false;

  DiamondDataSource();

  Future<void> initializeData() async {
    if (!_isInitialized) {
      await _loadDiamonds();
      _isInitialized = true;
    }
  }

  Future<void> _loadDiamonds() async {
    try {
      diamonds = await _firebaseService.fetchDiamonds();

      // If no diamonds exist in the database, add some sample data
      if (diamonds.isEmpty) {
        // Sample data
        diamonds = [
          Diamond(1, 1.5, 'VS1', 'D', 'John', 'Supplier A', DateTime.now(),
              'Available', 15000, 'Premium cut'),
          Diamond(2, 2.0, 'VVS2', 'E', 'Sarah', 'Supplier B', DateTime.now(),
              'In Process', 25000, 'Excellent polish'),
        ];

        // Add sample diamonds to Firebase
        for (var diamond in diamonds) {
          await _firebaseService.addDiamond(diamond);
        }

        // Add sample transactions
        for (var diamond in diamonds) {
          await _firebaseService.addTransaction(
              DiamondTransaction(
                diamond.id,
                DateTime.now(),
                diamond.receivedFrom,
                diamond.currentHolder,
                'Received',
                'Initial receipt of diamond',
              )
          );
        }
      }

      _generateDataGridRows();
      notifyListeners();
    } catch (e) {
      print('Error loading diamonds: $e');
      // Initialize with empty list if there's an error
      diamonds = [];
      _generateDataGridRows();
      notifyListeners();
    }
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

  Future<void> addDiamond(Diamond diamond) async {
    await _firebaseService.addDiamond(diamond);
    // After adding to Firebase, refresh the local list
    diamonds = await _firebaseService.fetchDiamonds();
    _generateDataGridRows();
    notifyListeners();
  }

  Future<void> updateDiamond(Diamond diamond) async {
    await _firebaseService.updateDiamond(diamond);
    // After updating in Firebase, refresh the local list
    diamonds = await _firebaseService.fetchDiamonds();
    _generateDataGridRows();
    notifyListeners();
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