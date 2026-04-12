import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'SQLHelper.dart';
void main() {
  runApp( DatabaseClass());
}

class DatabaseClass extends StatelessWidget {

  DatabaseClass({Key? key}) : super(key: key);


  late int currId;
  late String board;
  late String time;
  void isSaved(){
    print(time);
    print(board);
    print('CURRID ={$currId}');
    _HomePageState hp = new _HomePageState();
    print('you saved your data');
    hp.manualUpdate(currId, board, time);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'SQLITE',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // All journals
  List<Map<String, dynamic>> _journals = [];


  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await DatabaseHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }
  void manualUpdate(int id, String board, String time) async{

    final existingJournal =

    print('YOUR ID IS${id}');
    _titleController.text = board;
    _descriptionController.text = time;
    if (id!=0) {
      await _updateItem(id);
    }
    else{
      await _addItem();
    }
    //manually update the database
  }



  void _handleItemClick(int itemId) {
    DatabaseClass d = new DatabaseClass();
    d.currId=itemId;
    final clickedJournal = _journals.firstWhere((element) => element['id'] == itemId);
    final title = clickedJournal['title'];//this will have matrix
    String description = clickedJournal['description'];// this will have time
    Times a = new Times();
    a.setTime(int.parse(description));
    a.setId(itemId);
    a.setBoard(title);
    print('Time set to{$description}');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
    //create time_Counter class constructor
    //call obj.setTime(description.ToString())
    //create game_screen class constructor
    //call obj.setMat(title)
    print('Item clicked with ID: $itemId, Title: $title, Description: $description');
  }


  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item



  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Matrix'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'Time'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save new journal
                  if (id == null) {
                    await _addItem();
                  }

                  if (id != null) {
                    await _updateItem(id);
                  }

                  // Clear the text fields
                  _titleController.text = '';
                  _descriptionController.text = '';

                  // Close the bottom sheet
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create New' : 'Update'),
              )
            ],
          ),
        ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await DatabaseHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await DatabaseHelper.updateItem(
        id, _titleController.text, _descriptionController.text);

  }

  // Delete an item
  Future<void> _deleteItem(int id) async {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a State!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOAD STATE'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => GestureDetector(
          onDoubleTap: () => _handleItemClick(_journals[index]['id']),
          child: Card(
            color: Colors.orange[200],
            margin: const EdgeInsets.all(15),
            child: ListTile(
              title:  Text("Matrix Data"),
              subtitle: Text((_journals[index]['id']%6).toString()),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(_journals[index]['id']),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}

