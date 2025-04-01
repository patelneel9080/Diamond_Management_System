// import 'package:firebase_database/firebase_database.dart';
// import '../models/diamond.dart';
// import '../models/diamond_transaction.dart';
//
// class FirebaseService {
//   final DatabaseReference _diamondsRef =
//       FirebaseDatabase.instance.ref().child('diamonds');
//   final DatabaseReference _transactionsRef =
//       FirebaseDatabase.instance.ref().child('transactions');
//   final DatabaseReference _tablesRef =
//       FirebaseDatabase.instance.ref().child('tables');
//
//   // Fetch all diamonds
//   Future<List<Diamond>> fetchDiamonds() async {
//     try {
//       final snapshot = await _diamondsRef.get();
//       List<Diamond> diamonds = [];
//
//       if (snapshot.exists) {
//         Map<dynamic, dynamic> values = snapshot.value as Map;
//         values.forEach((key, value) {
//           diamonds.add(Diamond.fromMap(value, key));
//         });
//       }
//
//       return diamonds;
//     } catch (e) {
//       print('Error fetching diamonds: $e');
//       return [];
//     }
//   }
//
//   // Add new diamond
//   Future<void> addDiamond(Diamond diamond) async {
//     try {
//       await _diamondsRef.push().set(diamond.toMap());
//     } catch (e) {
//       print('Error adding diamond: $e');
//       throw e;
//     }
//   }
//
//   // Update existing diamond
//   Future<void> updateDiamond(Diamond diamond) async {
//     try {
//       if (diamond.firebaseKey != null) {
//         await _diamondsRef.child(diamond.firebaseKey!).update(diamond.toMap());
//       } else {
//         // If no key exists, we need to find the diamond by ID first
//         final snapshot =
//             await _diamondsRef.orderByChild('id').equalTo(diamond.id).get();
//
//         if (snapshot.exists) {
//           Map<dynamic, dynamic> values = snapshot.value as Map;
//           String key = values.keys.first;
//           await _diamondsRef.child(key).update(diamond.toMap());
//         } else {
//           throw Exception('Diamond not found in database');
//         }
//       }
//     } catch (e) {
//       print('Error updating diamond: $e');
//       throw e;
//     }
//   }
//
//   // Add transaction
//   Future<void> addTransaction(DiamondTransaction transaction) async {
//     try {
//       await _transactionsRef.push().set(transaction.toMap());
//     } catch (e) {
//       print('Error adding transaction: $e');
//       throw e;
//     }
//   }
//
//   // Fetch transactions for a specific diamond
//   Future<List<DiamondTransaction>> fetchTransactionsForDiamond(
//       int diamondId) async {
//     try {
//       final snapshot = await _transactionsRef
//           .orderByChild('diamondId')
//           .equalTo(diamondId)
//           .get();
//
//       List<DiamondTransaction> transactions = [];
//
//       if (snapshot.exists) {
//         Map<dynamic, dynamic> values = snapshot.value as Map;
//         values.forEach((key, value) {
//           transactions.add(DiamondTransaction.fromMap(value));
//         });
//       }
//
//       return transactions;
//     } catch (e) {
//       print('Error fetching transactions: $e');
//       return [];
//     }
//   }
//
//   // Save table configuration
//   Future<void> saveTableConfig(String tableName, List<String> columnNames,
//       List<String> columnHeaders) async {
//     try {
//       await _tablesRef.child(tableName).set({
//         'columnNames': columnNames,
//         'columnHeaders': columnHeaders,
//       });
//     } catch (e) {
//       print('Error saving table config: $e');
//       throw e;
//     }
//   }
//
//   // Fetch table configurations
//   Future<Map<String, dynamic>> fetchTableConfigs() async {
//     try {
//       final snapshot = await _tablesRef.get();
//
//       if (snapshot.exists) {
//         return snapshot.value as Map<String, dynamic>;
//       }
//
//       return {};
//     } catch (e) {
//       print('Error fetching table configs: $e');
//       return {};
//     }
//   }
// }
import 'package:firebase_database/firebase_database.dart';
import '../models/diamond.dart';
import '../models/diamond_transaction.dart';

class FirebaseService {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("diamonds");
  final DatabaseReference transactionsRef = FirebaseDatabase.instance.ref().child('transactions');
  final DatabaseReference tablesRef = FirebaseDatabase.instance.ref().child('tables');

  // Add new diamond data
  Future<void> addDiamondData({
    required String carat,
    required String clarity,
    required String price,
    required String receivedFrom,
    required String notes,
  }) async {
    try {
      await databaseRef.push().set({
        "Carat Weight": carat,
        "Clarity": clarity,
        "Price": price,
        "Received From": receivedFrom,
        "Notes": notes,
      });
      print("✅ Diamond data added successfully!");
    } catch (e) {
      print("❌ Error adding diamond data: $e");
    }
  }

  // Fetch diamond data
  Future<void> fetchDiamondData() async {
    try {
      databaseRef.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          print("📜 Diamond Data: ${event.snapshot.value}");
        } else {
          print("⚠️ No data found in Firebase.");
        }
      });
    } catch (e) {
      print("❌ Error fetching data: $e");
    }
  }

  // Update diamond data
  Future<void> updateDiamondData(String id, Map<String, dynamic> updatedData) async {
    try {
      await databaseRef.child(id).update(updatedData);
      print("✅ Diamond data updated successfully!");
    } catch (e) {
      print("❌ Error updating diamond data: $e");
    }
  }

  // Delete diamond data
  Future<void> deleteDiamondData(String id) async {
    try {
      await databaseRef.child(id).remove();
      print("✅ Diamond data deleted successfully!");
    } catch (e) {
      print("❌ Error deleting diamond data: $e");
    }
  }

  // Add transaction
  Future<void> addTransaction(DiamondTransaction transaction) async {
    try {
      await transactionsRef.push().set(transaction.toMap());
    } catch (e) {
      print('Error adding transaction: $e');
      throw e;
    }
  }

  // Fetch transactions for a specific diamond
  Future<List<DiamondTransaction>> fetchTransactionsForDiamond(int diamondId) async {
    try {
      final snapshot = await transactionsRef
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
      await tablesRef.child(tableName).set({
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
      final snapshot = await tablesRef.get();

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