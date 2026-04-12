import 'package:flutter/material.dart';
import 'package:init_project/DatabaseClass.dart';
import 'package:init_project/loading_page.dart';
import 'package:init_project/main.dart';
import 'package:init_project/you_win.dart';
import 'dart:async';
import 'package:init_project/SolveSudoku.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';
import 'dart:convert';
import 'you_win.dart';


class GameScreen extends StatefulWidget{
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}
class Times{
  static int elapsedTime=0;
  static int id=0;
  static String matrix='[]';
  static String diff ='';
  void setTime(int x){
    elapsedTime=x;
  }
  int giveTime(){
    return elapsedTime;
  }
  void setId(int id_){
    id=id_;
  }
  void setBoard(String mat){
    matrix =mat;
  }
  void setDiff(String d){
    diff = d;
  }
  String giveMatrix(){
    return matrix;
  }
  int giveId(){
    return id;
  }
  String getDiff(){
    return diff;
  }

}

class _GameScreenState extends State<GameScreen>{
  late List<List<int>> sudokuBoard;
  late int selectedNumber; // Track the selected number for editing cells
  late List<int> selectedCell; // Track the selected cell coordinates [row, col]
  late List<List<int>> fixedCells = [];
  late List<List<int>> copyList =[];
  late Timer _timer;
  late int elapsedTime;
  late int id;
  late String matrix;
  late int hintCount=0;
  late String diff = '';
  late List<List<int>> highlightedCells = [];


  @override
  void initState() {
    Times a = new Times();
    elapsedTime=a.giveTime();
    id = a.giveId();
    matrix = a.giveMatrix();
    diff = a.getDiff();
    super.initState();


    dynamic decodedObject = jsonDecode(matrix);
    if (matrix!="[]") {
      sudokuBoard = (decodedObject as List).map<List<int>>(
            (list) => (list as List).map<int>((e) => e as int).toList(),
      ).toList();
    }
    else{
      sudokuBoard=_generateSudokuBoard();
      for(int i=0;i<sudokuBoard.length;++i){
        for(int j=0;j<sudokuBoard[i].length;++j){
          sudokuBoard[i][j]*=10;

        }
      }
    }
/*
    for (int i=0;i<sudokuBoard.length;++i){
      for (int j=0;j<sudokuBoard[i].length;++j){
        if (sudokuBoard[i][j]>9){
          // bold them
        }
      }
    }
 */
    copyList =  sudokuBoard.map((List<int> sublist) => List<int>.from(sublist)).toList();
    for (int i=0;i<copyList.length;++i){
      for (int j=0;j<copyList[i].length;++j){
        if (copyList[i][j]>=10){
          int c=copyList[i][j]~/10;
          copyList[i][j] = c;
        }
        else{
          copyList[i][j]=0;
        }
      }
    }

    SudokuSolverLocal sudokuSolver = SudokuSolverLocal(copyList);


    _timer=Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {}); // Trigger a rebuild every second
    });

    if (sudokuSolver.solveSudoku()) {
      sudokuSolver.printSudoku();
    }

    selectedNumber = 0; // Initialize selectedNumber to 0 or any default value
    selectedCell = [-1, -1]; // Initialize selectedCell to an invalid value

  }

  @override
  void dispose() {

    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  List<List<int>> _generateSudokuBoard() {
    // You can implement your own Sudoku generation algorithm here.
    // For simplicity, let's use a hardcoded Sudoku board.
    int num=0;//Difficulty Level: Easy 32, Medium 54, Hard 69,
    if (diff=="REGULAR"){
      num=32;

    }
    else if(diff =="HARD"){
      num=54;
    }
    var sudokuGenerator = SudokuGenerator(
        emptySquares:
        num);
    return sudokuGenerator.newSudoku;


  }


  Widget _buildCell(int row, int col) {
    bool isBold = sudokuBoard[row][col] > 9;
    return GestureDetector(
      onTap: () {
        _selectCell(row, col);
      },
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(),
          color: highlightedCells.contains([row, col]) ||
              (selectedCell[0] ~/ 3 == row ~/ 3 && selectedCell[1] ~/ 3 == col ~/ 3)
              ? Colors.blue.shade50 // Highlight the 3x3 submatrix
              : (selectedCell[0] == row || selectedCell[1] == col)
              ? Colors.purple.shade50 // Highlight selected cell and row/column
              : (isBold ? Colors.grey : null),
        ),
        child: Text(
          sudokuBoard[row][col] != 0 ? sudokuBoard[row][col].toString() : '',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }



  Widget _buildNumberButton(int number) {
    String fill = number.toString();
    if (number == 10) {
      fill = 'Clear';
    } else if (number == 11) {
      fill = 'Reveal';
    }
    return ElevatedButton(
      onPressed: () {
        _fillSelectedCell(number);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.purple.shade50, // Choose your button color here
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
        ),
      ),
      child: Text(
        fill,
        style: TextStyle(fontSize: 16), // Adjust the font size as needed
      ),
    );
  }

  Widget _buildNumberBar() {
    return Column(
      children: [
        _buildNumberButton(11), // Reveal button at the top
        SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            for (int row = 1; row <= 9; row++)
              _buildNumberButton(row),
            _buildNumberButton(10), // Clear button at the end
          ],
        ),
      ],
    );
  }







  // void _selectCell(int row, int col) {
  //   setState(() {
  //     selectedCell = [row, col];
  //     // Add selected cell and its row/column to highlightedCells
  //     highlightedCells = []; // Clear previous highlights
  //     for (int i = 0; i < 9; i++) {
  //       highlightedCells.add([row, i]); // Highlight entire row
  //       highlightedCells.add([i, col]); // Highlight entire column
  //     }
  //   });
  // }


  void _selectCell(int row, int col) {
    // Check if the selected cell is not a gray cell
    if (sudokuBoard[row][col] < 10) {
      setState(() {
        selectedCell = [row, col];
        highlightedCells = _getHighlightedCells(row, col);
      });
    }
  }
  List<List<int>> _getHighlightedCells(int row, int col) {
    List<List<int>> highlighted = [];
    // Map the selected cell to its 3x3 submatrix
    int submatrixRow = row ~/ 3;
    int submatrixCol = col ~/ 3;

    // Iterate through the submatrix and add its cells to the highlighted list
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        highlighted.add([submatrixRow * 3 + i, submatrixCol * 3 + j]);
      }
    }
    return highlighted;
  }


  void _fillSelectedCell(int number) {
    bool found = false;
    for (int i=0;i<fixedCells.length;++i){
      if(fixedCells[i][0]==selectedCell[0] && fixedCells[i][1]==selectedCell[1]){
        found = true;
      }
    }
    //print(found);
    if(true) {
      if (selectedCell[0] != -1 && selectedCell[1] != -1 && number != 10 && number != 11 && sudokuBoard[selectedCell[0]][selectedCell[1]]<10 ) {
        setState(() {
          sudokuBoard[selectedCell[0]][selectedCell[1]] = number;
        });
      }
      else if (selectedCell[0] != -1 && selectedCell[1] != -1 && number == 10 && number != 11 && sudokuBoard[selectedCell[0]][selectedCell[1]]<10) {
        setState(() {
          sudokuBoard[selectedCell[0]][selectedCell[1]] = 0;
        });
      }
      else if (selectedCell[0] != -1 && selectedCell[1] != -1 && number == 11 && sudokuBoard[selectedCell[0]][selectedCell[1]]<10) {
        setState(() {
          sudokuBoard[selectedCell[0]][selectedCell[1]] = copyList[selectedCell[0]][selectedCell[1]];
          hintCount++;
          elapsedTime+=(hintCount*hintCount*hintCount);
        });
      }
    }
    bool solved = true;
    for (int i=0;i<sudokuBoard.length;++i){
      for (int j=0;j<sudokuBoard[0].length;++j){
        int a;
        if(sudokuBoard[i][j]<10){
          a = sudokuBoard[i][j];
        }
        else{
          a=sudokuBoard[i][j]~/10;
        }
        int b;
        if(copyList[i][j]<10){
          b = copyList[i][j];
        }
        else{
          b=copyList[i][j]~/10;
        }
        if (a!=b){
          solved = false;
        }
      }
    }
    if(solved == true){
      _timer.cancel();
      int sec=_timer.tick+elapsedTime;
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WinScreen(completionTime: sec),
          )
      );
    }

  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        // You can navigate to your desired page or perform any other actions
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loading()),
        );
        return false; // Return false to prevent default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sudoku Game'),

        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                //'TIME: ${((_timer.tick + elapsedTime)/60)}:${(_timer.tick+elapsedTime)%60}',
                'TIME: ${formatTime(_timer.tick + elapsedTime)}',
                // Display the elapsed time directly from the timer
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  _timer.cancel();
                  DatabaseClass dbc = new DatabaseClass();
                  dbc.time=(_timer.tick+elapsedTime).toString();
                  dbc.board=sudokuBoard.toString();
                  dbc.currId=id;
                  elapsedTime+=_timer.tick;

                  // Navigate to the game screen
                  dbc.isSaved();
                  _timer=Timer.periodic(Duration(seconds: 1), (timer) {
                    setState(() {}); // Trigger a rebuild every second
                  });
                },
                child: Text('Save State'),
              ),

              SizedBox(height: 20),


              for (var row = 0; row < sudokuBoard.length; row++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var col = 0; col < sudokuBoard[row].length; col++)
                      _buildCell(row, col),
                  ],
                ),
              SizedBox(height: 20),
              _buildNumberBar(), // Add the number bar below the Sudoku grid
            ],
          ),

        ),
      ),
    );
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
