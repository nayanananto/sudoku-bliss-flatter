class SudokuSolverLocal {
  List<List<int>> board;

  SudokuSolverLocal(this.board);

  bool solveSudoku() {

    var emptyCell = findEmptyCell();
    if (emptyCell == null) {
      return true; // Puzzle solved
    }

    for (int num = 1; num <= 9; num++) {
      if (isSafe(emptyCell[0], emptyCell[1], num)) {
        board[emptyCell[0]][emptyCell[1]] = num;

        if (solveSudoku()) {
          return true;
        }

        board[emptyCell[0]][emptyCell[1]] = 0; // Backtrack
      }
    }

    return false; // No solution found
  }

  List<int>? findEmptyCell() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] == 0) {
          return [i, j];
        }
      }
    }
    return null; // No empty cell
  }

  bool isSafe(int row, int col, int num) {
    return !usedInRow(row, num) &&
        !usedInCol(col, num) &&
        !usedInBox(row - row % 3, col - col % 3, num);
  }

  bool usedInRow(int row, int num) {
    return board[row].contains(num);
  }

  bool usedInCol(int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (board[i][col] == num) {
        return true;
      }
    }
    return false;
  }

  bool usedInBox(int startRow, int startCol, int num) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[startRow + i][startCol + j] == num) {
          return true;
        }
      }
    }
    return false;
  }

  void printSudoku() {
    for (int i = 0; i < 9; i++) {
      print(board[i]);
    }
  }
}
