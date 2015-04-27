#include <stdbool.h>
#include <assert.h>
#include <stdio.h>

// seq_has_duplicates(seq, len) determines if a char seq has duplicates.
// requires: seq is not NULL and len > 0
// effects: returns true if seq has duplicates
bool seq_has_duplicates(char seq[], int len) {
  assert(seq);
  assert(len > 0);
  for(int i = len - 1; i >= 0; i--) {
    for(int j = i - 1; j >= 0; j--) {
      if(seq[i] == '.' || seq[i] == '0') continue;
      if(seq[i] == seq[j]) return true;
    }
  }
  return false;
}

// is_col_valid(board) determines if nine columns in board are all valid. 
// requires: board is not NULL
bool is_col_valid(char board[]) {
  assert(board);
  for(int i = 1; i < 10; i++) {
    char col[9];
    for(int j = 0; j < 9; j++) {
      char point = board[9 * j + i];
      col[j] = point;
    }
    if(seq_has_duplicates(col, 9)) {
      return false;
      break;
    }
  }
  return true;
}

// is_row_valid(board) determines if nine rows in board are all valid.
// requires: board is not NULL
bool is_row_valid(char board[]) {
  assert(board);
  for(int i = 0; i < 9; i++) {
    char row[9];
    for(int j = 0; j < 9; j++) {
      char point = board[i * 9 + j];
      row[j] = point;
    } 
    if(seq_has_duplicates(row, 9)) {
      return false;
      break;
    }
  }
  return true;
}

// is_sqr_valid(board) determines if nine squares in board are all valid.
// requires: board is not NULL
bool is_sqr_valid(char board[]) {
  assert(board);
  for(int i = 0; i < 3; i++) {
    for(int j = 0; j <= 6; j += 3) {      
      int start = i * 27 + j;
      char sqr[9];  
      int count = 0;           
        for(int m = start; m <= start + 18; m += 9) {
          for(int n = 0; n < 3; n++) {
            sqr[count] = board[m + n];
            ++count;
          }
        }        
      if(seq_has_duplicates(sqr, 9)) {
      return false;
      break;
      } 
    }
  }
  return true;
}  

// is_valid(board) determines if a sudoku board is valid.
// reuiqres: board is not NULL
bool is_valid(char board[]) {
  assert(board);
  return is_row_valid(board) && is_col_valid(board) && is_sqr_valid(board);
}

