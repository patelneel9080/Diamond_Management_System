import 'package:firebase_database/firebase_database.dart';
import '../models/diamond.dart';
import '../models/diamond_transaction.dart';

class FirebaseService {
  final DatabaseReference _diamondsRef = FirebaseDatabase.instance.ref().child('diamonds');
  final DatabaseReference _transactionsRef = FirebaseDatabase.instance.ref().child('transactions');
  final DatabaseReference _tablesRef = FirebaseDatabase.instance.ref().child('tables');

  // Fetch all diamonds
  Future<List<Diamond>> fetchDiamonds() async {
    try {
      final snapshot = await _diamondsRef.get();
      List<Diamond> diamonds = [];

      if (snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.value as Map;
        values.forEach((key, value) {
          diamonds.add(Diamond.fromMap(value, key));
        });
      }

      return diamonds;
    } catch (e) {
      print('Error fetching diamonds: $e');
      return [];
    }
  }

  // Add new diamond
  Future<void> addDiamond(Diamond diamond) async {
    try {
      await _diamondsRef.push().set(diamond.toMap());
    } catch (e) {
      print('Error adding diamond: $e');
      throw e;
    }
  }

  // Update existing diamond
  Future<void> updateDiamond(Diamond diamond) async {
    try {
      if (diamond.firebaseKey != null) {
        await _diamondsRef.child(diamond.firebaseKey!).update(diamond.toMap());
      } else {
        // If no key exists, we need to find the diamond by ID first
        final snapshot = await _diamondsRef
            .orderByChild('id')
            .equalTo(diamond.id)
            .get();

        if (snapshot.exists) {
          Map<dynamic, dynamic> values = snapshot.value as Map;
          String key = values.keys.first;
          await _diamondsRef.child(key).update(diamond.toMap());
        } else {
          throw Exception('Diamond not found in database');
        }
      }
    } catch (e) {
      print('Error updating diamond: $e');
      throw e;
    }
  }

  // Add transaction
  Future<void> addTransaction(DiamondTransaction transaction) async {
    try {
      await _transactionsRef.push().set(transaction.toMap());
    } catch (e) {
      print('Error adding transaction: $e');
      throw e;
    }
  }

  // Fetch transactions for a specific diamond
  Future<List<DiamondTransaction>> fetchTransactionsForDiamond(int diamondId) async {
    try {
      final snapshot = await _transactionsRef
          .orderByChild('diamondId')
          .equalTo(diamondId)
          .get();

      List<DiamondTransaction> transactions = [];

      if (snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.value as Map;
        values.forEach((key, value) {
          transactions.add(DiamondTransaction.fromMap(value));
        });
      }

      return transactions;
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  // Save table configuration
  Future<void> saveTableConfig(String tableName, List<String> columnNames, List<String> columnHeaders) async {
    try {
      await _tablesRef.child(tableName).set({
        'columnNames': columnNames,
        'columnHeaders': columnHeaders,
      });
    } catch (e) {
      print('Error saving table config: $e');
      throw e;
    }
  }

  // Fetch table configurations
  Future<Map<String, dynamic>> fetchTableConfigs() async {
    try {
      final snapshot = await _tablesRef.get();

      if (snapshot.exists) {
        return snapshot.value as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      print('Error fetching table configs: $e');
      return {};
    }
  }
}