import 'package:firebase_auth/firebase_auth.dart';
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
      home: const LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if the user is already logged in
  Future<void> _checkLoginStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // User is already logged in, navigate to main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DiamondManagementScreen()),
      );
    }
  }

  // Log in with email and password
  Future<void> _login() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // On successful login, navigate to the main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DiamondManagementScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found with this email.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Incorrect password.';
        } else {
          _errorMessage = e.message ?? 'An error occurred during login.';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo or icon
                        Icon(
                          Icons.diamond_outlined,
                          size: 80,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(height: 16),

                        // Title
                        const Text(
                          'Diamond Management',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          'Sign in to your account',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Error message
                        if (_errorMessage.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _errorMessage,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_errorMessage.isNotEmpty)
                          const SizedBox(height: 24),

                        // Email field
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),

                        // Password field
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                            ),
                          ),
                          obscureText: _obscurePassword,
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Add forgot password functionality
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Registration option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to registration page
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class Diamond {
  Diamond({
    required this.id,
    required this.caratWeight,
    required this.clarity,
    required this.color,
    required this.currentHolder,
    required this.receivedFrom,
    required this.receivedDate,
    required this.status,
    required this.price,
    required this.notes,
    this.firebaseKey, // Optional Firebase key
  });

  final int id;
  double caratWeight;
  String clarity;
  String color;
  String currentHolder;
  String receivedFrom;
  DateTime receivedDate;
  String status;
  double price;
  String notes;
  String? firebaseKey; // To store the unique key from Firebase

  // Convert Diamond to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'Carat Weight': caratWeight.toString(),
      'Clarity': clarity,
      'Color': color,
      'Current Holder': currentHolder,
      'Received From': receivedFrom,
      'Received Date': receivedDate.toIso8601String(),
      'Status': status,
      'Price': price.toString(),
      'Notes': notes,
      'id': id.toString(), // Include id for consistency
    };
  }

  // Create Diamond from Firebase data
  static Diamond fromMap(String key, Map<String, dynamic> data) {
    return Diamond(
      id: int.parse(data['id'] ?? '0'), // Use stored id or default to 0
      caratWeight: double.parse(data['Carat Weight'] ?? '0'),
      clarity: data['Clarity'] ?? '',
      color: data['Color'] ?? '',
      currentHolder: data['Current Holder'] ?? '',
      receivedFrom: data['Received From'] ?? '',
      receivedDate:
      DateTime.parse(data['Received Date'] ?? DateTime.now().toIso8601String()),
      status: data['Status'] ?? 'Available',
      price: double.parse(data['Price'] ?? '0'),
      notes: data['Notes'] ?? '',
      firebaseKey: key,
    );
  }
}

// class Diamond {
//   Diamond(
//     this.id,
//     this.caratWeight,
//     this.clarity,
//     this.color,
//     this.currentHolder,
//     this.receivedFrom,
//     this.receivedDate,
//     this.status,
//     this.price,
//     this.notes,
//   );
//
//   final int id;
//   double caratWeight;
//   String clarity;
//   String color;
//   String currentHolder;
//   String receivedFrom;
//   DateTime receivedDate;
//   String status; // Available, In Process, Sold
//   double price;
//   String notes;
// }

class DiamondTransaction {
  final int diamondId;
  final DateTime date;
  final String fromPerson;
  final String toPerson;
  final String action; // Received, Transferred, Sold
  final String notes;
  final String tableNode; // To identify which table the diamond belongs to

  DiamondTransaction(
      this.diamondId,
      this.date,
      this.fromPerson,
      this.toPerson,
      this.action,
      this.notes,
      this.tableNode,
      );

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'diamondId': diamondId,
      'date': date.toIso8601String(),
      'fromPerson': fromPerson,
      'toPerson': toPerson,
      'action': action,
      'notes': notes,
      'tableNode': tableNode,
    };
  }

  // Create from Firebase data
  static DiamondTransaction fromMap(Map<String, dynamic> data) {
    return DiamondTransaction(
      data['diamondId'] ?? 0,
      DateTime.parse(data['date'] ?? DateTime.now().toIso8601String()),
      data['fromPerson'] ?? '',
      data['toPerson'] ?? '',
      data['action'] ?? '',
      data['notes'] ?? '',
      data['tableNode'] ?? '',
    );
  }
}

class TableInfo {
  String name;
  String firebaseNodeName; // Add this to store the Firebase node name
  DiamondDataSource dataSource;
  List<GridColumn> columns;
  List<String> columnNames;
  List<String> columnHeaders;
  List<Diamond> selectedDiamonds = [];

  TableInfo({
    required this.name,
    required this.firebaseNodeName, // Add this parameter
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
  late DatabaseReference _tablesRef;
  bool _isLoading = true; // Already defined
  late DatabaseReference _transactionsRef;

  @override
  void initState() {
    super.initState();

    // Initialize the Firebase reference for the 'tables' node
    _tablesRef = FirebaseDatabase.instance.ref();
    _transactionsRef = FirebaseDatabase.instance.ref('transactions');

    // Fetch tables from Firebase
    _fetchTables();
    _fetchTransactions();
  }
  Future<void> _fetchTransactions() async {
    try {
      DatabaseReference transactionsRef = FirebaseDatabase.instance.ref('transactions');
      DatabaseEvent event = await transactionsRef.once();
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        transactions.clear();
        data.forEach((diamondId, transactionsData) {
          if (transactionsData is Map) {
            transactionsData.forEach((key, value) {
              Map<String, dynamic> transactionData = Map<String, dynamic>.from(value);
              transactions.add(DiamondTransaction.fromMap(transactionData));
            });
          }
        });
      }
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }
  Future<void> _fetchTables() async {
    try {
      // Reference to the root of the database
      DatabaseReference rootRef = FirebaseDatabase.instance.ref();
      DatabaseEvent event = await rootRef.once();
      print("Fetched root data: ${event.snapshot.value}");

      // Clear existing tables
      tables.clear();

      // If data exists at the root, process it
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        Map<dynamic, dynamic> rootData = event.snapshot.value as Map<dynamic, dynamic>;

        // Iterate through all top-level nodes
        rootData.forEach((key, value) {
          String nodeName = key.toString();

          // Skip the 'tables' node since we don't want to display it
          if (nodeName == 'tables') return;

          // Only process nodes that are Maps (i.e., actual data tables)
          if (value is Map) {
            // Convert node name to a display name (e.g., "new-diamonds" -> "New Diamonds")
            String displayName = nodeName
                .replaceAll('-', ' ')
                .split(' ')
                .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
                .join(' ');

            print("Found table: $displayName with node: $nodeName");
            tables.add(_createTableFromMetadata(displayName, nodeName));
          }
        });
      }

      // If no tables were found, create a default "Diamonds" table
      if (tables.isEmpty) {
        tables.add(_createTableFromMetadata("Diamonds", "diamonds"));
        // Create the node in Firebase if it doesn't exist
        await rootRef.child("diamonds").set({});
      }

      // Initialize tab controller
      _tabController = TabController(length: tables.length, vsync: this);
      _tabController.addListener(() {
        setState(() {
          tabIndex = _tabController.index;
        });
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching tables: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tables: $e')),
      );

      // Fallback: create a default table
      if (tables.isEmpty) {
        tables.add(_createTableFromMetadata("Diamonds", "diamonds"));
        _tabController = TabController(length: tables.length, vsync: this);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
  TableInfo _createTableFromMetadata(String name, String firebaseNodeName) {
    print("Creating table: $name with node: $firebaseNodeName");
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

    DiamondDataSource dataSource = DiamondDataSource(nodeName: firebaseNodeName);
    List<GridColumn> columns = _generateColumns(columnNames, columnHeaders);

    TableInfo table = TableInfo(
      name: name,
      firebaseNodeName: firebaseNodeName,
      dataSource: dataSource,
      columns: columns,
      columnNames: columnNames,
      columnHeaders: columnHeaders,
    );

    print("Table created with ${table.dataSource.diamonds.length} initial records");
    return table;
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

    // Create data source with the "diamonds" node
    DiamondDataSource dataSource = DiamondDataSource(nodeName: 'diamonds');

    // Create columns
    List<GridColumn> columns = _generateColumns(columnNames, columnHeaders);

    return TableInfo(
      name: 'Diamonds',
      firebaseNodeName: 'diamonds', // Specify the Firebase node name
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
    final nameController = TextEditingController();

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
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                String tableName = nameController.text;
                String nodeName = tableName.toLowerCase().replaceAll(' ', '-');

                // Check if table already exists by querying the root
                DatabaseReference rootRef = FirebaseDatabase.instance.ref();
                DatabaseEvent event = await rootRef.child(nodeName).once();

                if (event.snapshot.value != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Table "$tableName" already exists')),
                  );
                  Navigator.pop(context);
                  return;
                }

                // Create the new node in Firebase (empty for now)
                await rootRef.child(nodeName).set({});

                // Add to local tables list
                setState(() {
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

                  DiamondDataSource dataSource = DiamondDataSource(nodeName: nodeName);
                  List<GridColumn> columns = _generateColumns(columnNames, columnHeaders);

                  tables.add(TableInfo(
                    name: tableName,
                    firebaseNodeName: nodeName,
                    dataSource: dataSource,
                    columns: columns,
                    columnNames: columnNames,
                    columnHeaders: columnHeaders,
                  ));

                  // Update tab controller
                  _tabController.dispose();
                  _tabController = TabController(
                    length: tables.length,
                    vsync: this,
                    initialIndex: tables.length - 1,
                  );
                  tabIndex = tables.length - 1;
                });
                Navigator.pop(context);
              }
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
                // Optionally, update the table metadata in Firebase if needed
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
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  final currentTable = tables[tabIndex];
                  final newDiamond = Diamond(
                    id: currentTable.dataSource.diamonds.length + 1, // Generate ID
                    caratWeight: double.parse(caratController.text),
                    clarity: clarityController.text,
                    color: colorController.text,
                    currentHolder: receivedFromController.text, // Initial holder
                    receivedFrom: receivedFromController.text,
                    receivedDate: DateTime.now(),
                    status: 'Available',
                    price: double.parse(priceController.text),
                    notes: notesController.text,
                  );

                  currentTable.dataSource.addDiamond(newDiamond);

                  // Record the transaction in Firebase
                  _transactionsRef.push().set(DiamondTransaction(
                    newDiamond.id,
                    DateTime.now(),
                    receivedFromController.text,
                    receivedFromController.text,
                    'Received',
                    'Initial receipt of diamond',
                    currentTable.firebaseNodeName, // Store the table node
                  ).toMap());
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

                // Record the transaction in Firebase
                _transactionsRef.push().set(DiamondTransaction(
                  diamond.id,
                  DateTime.now(),
                  fromPerson,
                  toPersonController.text,
                  'Transferred',
                  notesController.text,
                  currentTable.firebaseNodeName, // Store the table node
                ).toMap());

                currentTable.dataSource.updateDiamond(diamond);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Transfer', style: TextStyle(color: Colors.white)),
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

    // Fetch transactions from Firebase
    _transactionsRef.once().then((DatabaseEvent event) {
      List<DiamondTransaction> diamondTransactions = [];
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        diamondTransactions = data.entries
            .map((entry) {
          Map<String, dynamic> transactionData = Map<String, dynamic>.from(entry.value);
          DiamondTransaction transaction = DiamondTransaction.fromMap(transactionData);
          // Filter transactions for the selected diamond and table
          if (transaction.diamondId == diamond.id &&
              transaction.tableNode == currentTable.firebaseNodeName) {
            return transaction;
          }
          return null;
        })
            .where((transaction) => transaction != null)
            .cast<DiamondTransaction>()
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      }

      // Show the transaction history dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Transaction History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Container(
            width: double.maxFinite,
            child: diamondTransactions.isEmpty
                ? const Center(child: Text('No transaction history available'))
                : ListView.builder(
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
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching transaction history: $error')),
      );
    });
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
        bottom: _isLoading
            ? null // Don't show TabBar while loading
            : TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tables.map((table) => Tab(text: table.name)).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : TabBarView(
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
  late DatabaseReference _databaseRef; // Make this late-initialized

  DiamondDataSource({required String nodeName}) {
    _databaseRef = FirebaseDatabase.instance.ref(nodeName);
    print("Initializing data source for node: $nodeName"); // Debug
    _fetchInitialData();
    _setupListener();
  }

  // Fetch initial data from Firebase
  void _fetchInitialData() async {
    try {
      DatabaseEvent event = await _databaseRef.once();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        diamonds = data.entries.map((entry) {
          Map<String, dynamic> diamondData = Map<String, dynamic>.from(entry.value);
          return Diamond.fromMap(entry.key, diamondData);
        }).toList();
        _generateDataGridRows();
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching initial data: $e");
    }
  }

  // Set up real-time listener for database changes
  void _setupListener() {
    _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        diamonds = data.entries.map((entry) {
          Map<String, dynamic> diamondData = Map<String, dynamic>.from(entry.value);
          return Diamond.fromMap(entry.key, diamondData);
        }).toList();
        _generateDataGridRows();
        notifyListeners();
      } else {
        diamonds = []; // Clear list if no data exists
        _generateDataGridRows();
        notifyListeners();
      }
    });
  }

  // Add a new diamond to Firebase
  void addDiamond(Diamond diamond) {
    _databaseRef.push().set(diamond.toMap()).then((_) {
      print("Diamond added successfully");
    }).catchError((error) {
      print("Error adding diamond: $error");
    });
    // Listener will update the local list automatically
  }

  // Update an existing diamond in Firebase
  void updateDiamond(Diamond diamond) {
    if (diamond.firebaseKey != null) {
      _databaseRef.child(diamond.firebaseKey!).set(diamond.toMap()).then((_) {
        print("Diamond updated successfully");
      }).catchError((error) {
        print("Error updating diamond: $error");
      });
      // Listener will handle the update
    }
  }

  void _generateDataGridRows() {
    _dataGridRows = diamonds.map<DataGridRow>((diamond) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: diamond.id),
        DataGridCell<double>(columnName: 'caratWeight', value: diamond.caratWeight),
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

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dataGridCell.value.toString(),
            style: const TextStyle(fontSize: 14),
          ),
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