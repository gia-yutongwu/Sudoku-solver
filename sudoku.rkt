;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname sudoku) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require "a10lib.rkt")

;;  
;;***************************************************   
;;Yutong Wu (20553361)  
;;CS 135 Fall 2014  
;;Assignment 10, Problem 3 (sudoku)  
;;***************************************************  
;; 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A SudokuDigit is one of:
;; * '?
;; * 1 <= Nat <= 9

;; A Puzzle is a (listof (listof SudokuDigit))
;; requires: the list and all sublists have a length of 9

;; A Solution is a Puzzle
;; requires: none of the SudokuDigits are '?
;;           the puzzle satisfies the number placement 
;;             rules of sudoku

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Here are some sample sudoku puzzles

;; From the basic test shown in the assignment:
(define veryeasy
  '((? 4 5 8 9 3 7 1 6)
    (8 1 3 5 7 6 9 2 4)
    (7 6 9 2 1 4 5 3 8)
    (5 3 6 9 8 7 1 4 2)
    (4 9 2 1 6 5 8 7 3)
    (1 7 8 4 3 2 6 5 9)
    (6 8 4 7 2 1 3 9 5)
    (3 2 1 6 5 9 4 8 7)
    (9 5 7 3 4 8 2 6 1)))

;; the above puzzle with more blanks:
(define easy
  '((? 4 5 8 ? 3 7 1 ?)
    (8 1 ? ? ? ? ? 2 4)
    (7 ? 9 ? ? ? 5 ? 8)
    (? ? ? 9 ? 7 ? ? ?)
    (? ? ? ? 6 ? ? ? ?)
    (? ? ? 4 ? 2 ? ? ?)
    (6 ? 4 ? ? ? 3 ? 5)
    (3 2 ? ? ? ? ? 8 7)
    (? 5 7 3 ? 8 2 6 ?)))

;; the puzzle listed on wikipedia
(define wikipedia '((5 3 ? ? 7 ? ? ? ?)
                    (6 ? ? 1 9 5 ? ? ?)
                    (? 9 8 ? ? ? ? 6 ?)
                    (8 ? ? ? 6 ? ? ? 3)
                    (4 ? ? 8 ? 3 ? ? 1)
                    (7 ? ? ? 2 ? ? ? 6)
                    (? 6 ? ? ? ? 2 8 ?)
                    (? ? ? 4 1 9 ? ? 5)
                    (? ? ? ? 8 ? ? 7 9)))

;; A blank puzzle template for you to use:
(define blank '((? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)
                (? ? ? ? ? ? ? ? ?)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Merry Christmas!
;; I love CS 135!!!!!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Constant definitions
(define basic '(1 2 3 4 5 6 7 8 9))

(define row1 '(11 12 13 14 15 16 17 18 19))
(define row2 '(21 22 23 24 25 26 27 28 29))
(define row3 '(31 32 33 34 35 36 37 38 39))
(define row4 '(41 42 43 44 45 46 47 48 49))
(define row5 '(51 52 53 54 55 56 57 58 59))
(define row6 '(61 62 63 64 65 66 67 68 69))
(define row7 '(71 72 73 74 75 76 77 78 79))
(define row8 '(81 82 83 84 85 86 87 88 89))
(define row9 '(91 92 93 94 95 96 97 98 99))

(define squ1 '(11 12 13 21 22 23 31 32 33))
(define squ2 '(14 15 16 24 25 26 34 35 36))
(define squ3 '(17 18 19 27 28 29 37 38 39))
(define squ4 '(41 42 43 51 52 53 61 62 63))
(define squ5 '(44 45 46 54 55 56 64 65 66))
(define squ6 '(47 48 49 57 58 59 67 68 69)) 
(define squ7 '(71 72 73 81 82 83 91 92 93))
(define squ8 '(74 75 76 84 85 86 94 95 96))
(define squ9 '(77 78 79 87 88 89 97 98 99))

;; Puzzle definitions for testing

(define answer-to-easy
  '((2 4 5 8 9 3 7 1 6)
    (8 1 3 5 7 6 9 2 4)
    (7 6 9 2 1 4 5 3 8)
    (5 3 6 9 8 7 1 4 2)
    (4 9 2 1 6 5 8 7 3)
    (1 7 8 4 3 2 6 5 9)
    (6 8 4 7 2 1 3 9 5)
    (3 2 1 6 5 9 4 8 7)
    (9 5 7 3 4 8 2 6 1)))

(define puzzle-messy
  '((? ? ? 8 ? 9 ? ? ?)
    (? ? 5 ? ? ? 7 ? ?)
    (? 2 9 ? 1 ? 6 4 ?)
    (7 ? ? ? 6 ? ? ? 2)
    (? ? 6 2 ? 4 3 ? ?)
    (8 ? ? ? 7 ? ? ? 6)
    (? 3 7 ? 2 ? 8 1 ?) 
    (? ? 1 ? ? ? 5 ? ?)
    (? ? ? 1 ? 3 ? ? ?)))

(define puzzle-surround
  '((? ? 6 4 8 1 3 ? ?)
    (? 2 ? ? ? ? ? 4 ?)
    (7 ? ? ? ? ? ? ? 9)
    (8 ? ? ? 9 ? ? ? 4)
    (6 ? ? 3 4 2 ? ? 1)
    (5 ? ? ? 6 ? ? ? 2)
    (3 ? ? ? ? ? ? ? 5)
    (? 9 ? ? ? ? ? 7 ?)
    (? ? 5 7 1 6 2 ? ?)))

(define answer-to-surround
  '((9 5 6 4 8 1 3 2 7)
    (1 2 3 6 7 9 5 4 8)
    (7 4 8 2 5 3 6 1 9)
    (8 3 2 1 9 5 7 6 4)
    (6 7 9 3 4 2 8 5 1)
    (5 1 4 8 6 7 9 3 2)
    (3 6 7 9 2 4 1 8 5)
    (2 9 1 5 3 8 4 7 6)
    (4 8 5 7 1 6 2 9 3)))

(define answer-to-veryeasy
  '((2 4 5 8 9 3 7 1 6)
    (8 1 3 5 7 6 9 2 4)
    (7 6 9 2 1 4 5 3 8)
    (5 3 6 9 8 7 1 4 2)
    (4 9 2 1 6 5 8 7 3)
    (1 7 8 4 3 2 6 5 9)
    (6 8 4 7 2 1 3 9 5)
    (3 2 1 6 5 9 4 8 7)
    (9 5 7 3 4 8 2 6 1)))

(define puzzle-wrong
  '((? ? ? 1 ? 5 ? 6 8)
    (? ? ? ? ? ? 7 ? 1)
    (9 ? 1 ? ? ? ? 3 ?)
    (? ? 7 ? 2 6 ? ? ?)
    (5 ? ? ? ? ? ? ? 3)
    (? 4 ? 8 7 ? 4 ? ?)
    (? 3 ? ? ? ? 8 ? 5)
    (1 ? 5 ? ? ? ? ? ?)
    (7 9 ? 4 ? 1 ? ? ?)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (build-board d) consumes a natural number d and creates a list of 
;;   lists of natural numbers representing a d*d square table
;; build-board: Nat -> (listof (listof Nat))
;; requires: d is positive
;; examples:
(check-expect (build-board 3) '((11 12 13) (21 22 23) (31 32 33)))
(check-expect (build-board 1) '((11)))

(define (build-board n)
  (build-list n (lambda (row) (build-list n (lambda (col) (+ (* 10 (add1 row)) (add1 col)))))))

;; tests:
(check-expect (build-board 2) '((11 12) (21 22)))
(check-expect (build-board 4) '((11 12 13 14) (21 22 23 24) (31 32 33 34) (41 42 43 44)))

;; (flat lst) consumes a list and creats a new list by taking out the lists inside of each element
;; flat: (listof Any) -> (listof Any)
;; examples:
(check-expect (flat '(((2) (3))(4) (5))) '((2) (3) 4 5))
(check-expect (flat '(("cs") ("135") ("rocks"))) '("cs" "135" "rocks"))

(define (flat lst)
  (cond [(empty? lst) empty]
        [(empty? (first lst)) (flat (rest lst))]
        [(empty? (rest (first lst))) (cons (first (first lst)) (flat (rest lst)))]
        [else (append (cons (first (first lst)) (rest (first lst))) (flat (rest lst)))]))

;; tests:
(check-expect (flat '(() (Andrew) (Garfield))) '(Andrew Garfield))
(check-expect (flat '()) '())

;; (solved? puzzle) consumes a Puzzle(puzzle) and produces true if puzzle is solved and false otherwise
;; solved?: Puzzle -> Bool
;; requires: Puzzle must not contain duplicates in every row, column and square
;; examples:
(check-expect (solved? answer-to-easy) true)
(check-expect (solved? wikipedia) false)

(define (solved? puzzle)
  (andmap (lambda (digit-lst) (not (member? '? digit-lst))) puzzle))

;; tests:
(check-expect (solved? veryeasy) false)
(check-expect (solved? easy) false)

;; (sudoku puzzle) produces a Solution corresponding to the answer of 
;;   the input puzzle or false if a solution does not exist
;; sudoku: Puzzle -> (anyof false Solution)
;; examples:
(check-expect (sudoku veryeasy) answer-to-veryeasy)
(check-expect (sudoku easy) answer-to-easy)

(define (sudoku puzzle)
  (local [;; (make-al puzzle) creats an association list combining every SudokuDigit 
          ;;   in Puzzle(puzzle) with a number between 11 and 99
          ;; Puzzle -> (listof (list Nat SudokuDigit))
          (define (make-al puzzle)
            (flat (map (lambda (row col) 
                         (map (lambda (row-d coln-d) (list row-d coln-d)) row col)) (build-board 9) puzzle)))
          ;; (row spot puzzle) produces all the spots in the row that spot is in in puzzle
          ;; row: (list Nat SudokuDigit) ->  (listof (list Nat SudokuDigit))
          (define (row spot puzzle)
            (cond [(member? (first spot) row1) 
                   (filter (lambda (spot) (member? (first spot) row1)) (make-al puzzle))]
                  [(member? (first spot) row2) 
                   (filter (lambda (spot) (member? (first spot) row2)) (make-al puzzle))]
                  [(member? (first spot) row3) 
                   (filter (lambda (spot) (member? (first spot) row3)) (make-al puzzle))]
                  [(member? (first spot) row4) 
                   (filter (lambda (spot) (member? (first spot) row4)) (make-al puzzle))]
                  [(member? (first spot) row5) 
                   (filter (lambda (spot) (member? (first spot) row5)) (make-al puzzle))]
                  [(member? (first spot) row6)
                   (filter (lambda (spot) (member? (first spot) row6)) (make-al puzzle))]
                  [(member? (first spot) row7) 
                   (filter (lambda (spot) (member? (first spot) row7)) (make-al puzzle))]
                  [(member? (first spot) row8) 
                   (filter (lambda (spot) (member? (first spot) row8)) (make-al puzzle))]
                  [else (filter (lambda (spot) (member? (first spot) row9)) (make-al puzzle))]))
          ;; (column spot puzzle) produces all the spots in the column that spot is in in puzzle
          ;; column: (list Nat SudokuDigit) ->  (listof (list Nat SudokuDigit))
          (define (column spot puzzle)
            (cond [(= 1 (remainder (first spot) 10)) 
                   (filter (lambda (spot) (= 1 (remainder (first spot) 10))) (make-al puzzle))]
                  [(= 2 (remainder (first spot) 10)) 
                   (filter (lambda (spot) (= 2 (remainder (first spot) 10))) (make-al puzzle))]
                  [(= 3 (remainder (first spot) 10)) 
                   (filter (lambda (spot) (= 3 (remainder (first spot) 10))) (make-al puzzle))]
                  [(= 4 (remainder (first spot) 10)) 
                   (filter (lambda (spot) (= 4 (remainder (first spot) 10))) (make-al puzzle))]
                  [(= 5 (remainder (first spot) 10)) 
                   (filter (lambda (spot) (= 5 (remainder (first spot) 10))) (make-al puzzle))]
                  [(= 6 (remainder (first spot) 10)) 
                   (filter (lambda (spot) (= 6 (remainder (first spot) 10))) (make-al puzzle))]
                  [(= 7 (remainder (first spot) 10)) 
                   (filter (lambda (spot) (= 7 (remainder (first spot) 10))) (make-al puzzle))]
                  [(= 8 (remainder (first spot) 10)) 
                   (filter (lambda (spot) (= 8 (remainder (first spot) 10))) (make-al puzzle))]
                  [else (filter (lambda (spot) (= 9 (remainder (first spot) 10))) (make-al puzzle))]))
          ;; (square spot puzzle) produces all the spots in the square that spot is in in puzzle
          ;; square: (list Nat SudokuDigit) ->  (listof (list Nat SudokuDigit))
          (define (square spot puzzle)
            (cond [(member? (first spot) squ1) 
                   (filter (lambda (spot) (member? (first spot) squ1)) (make-al puzzle))]
                  [(member? (first spot) squ2) 
                   (filter (lambda (spot) (member? (first spot) squ2)) (make-al puzzle))]
                  [(member? (first spot) squ3) 
                   (filter (lambda (spot) (member? (first spot) squ3)) (make-al puzzle))]
                  [(member? (first spot) squ4) 
                   (filter (lambda (spot) (member? (first spot) squ4)) (make-al puzzle))]
                  [(member? (first spot) squ5) 
                   (filter (lambda (spot) (member? (first spot) squ5)) (make-al puzzle))]
                  [(member? (first spot) squ6) 
                   (filter (lambda (spot) (member? (first spot) squ6)) (make-al puzzle))]
                  [(member? (first spot) squ7) 
                   (filter (lambda (spot) (member? (first spot) squ7)) (make-al puzzle))]
                  [(member? (first spot) squ8) 
                   (filter (lambda (spot) (member? (first spot) squ8)) (make-al puzzle))]
                  [(member? (first spot) squ9) 
                   (filter (lambda (spot) (member? (first spot) squ9)) (make-al puzzle))]))
          ;; (possi-num spot puzzle) produces a list of Nat among 1 to 9 that fit in the spot in puzzle
          ;; possi-num: (list Nat SudokuDigit) Puzzle -> (listof Nat)
          (define (possi-num spot puzzle)
            (filter (lambda (num) 
                      (not (or (member? num (map (lambda (x) (second x)) (row spot puzzle)))
                               (member? num (map (lambda (x) (second x)) (column spot puzzle)))
                               (member? num (map (lambda (x) (second x)) (square spot puzzle)))))) basic))          
          ;; (available-spot puzzle) produces a list of (list Nat SudokuDigit) that are not filled in puzzle
          ;; available-spot: Puzzle -> (listof (list Nat SudokuDigit))
          (define (available-spot puzzle)
            (first (filter (lambda (x) (equal? (second x) '?)) (make-al puzzle))))
          ;; (revocer al) produces a Puzzle from an association list 
          ;; recover: (listof (list Nat SudokuDigit)) -> Puzzle
          (define (recover al)
            (list (filter (lambda (x) (member? (first x) row1)) al)
                  (filter (lambda (x) (member? (first x) row2)) al)
                  (filter (lambda (x) (member? (first x) row3)) al)
                  (filter (lambda (x) (member? (first x) row4)) al)
                  (filter (lambda (x) (member? (first x) row5)) al)
                  (filter (lambda (x) (member? (first x) row6)) al)
                  (filter (lambda (x) (member? (first x) row7)) al)
                  (filter (lambda (x) (member? (first x) row8)) al)
                  (filter (lambda (x) (member? (first x) row9)) al)))
          ;; (replace-one spot puzzle) produces a new Puzzle by replacing the spot with valid numbers in puzzle
          ;; replace-one: (list Nat SudokuDigit) Puzzle -> Puzzle
          (define (replace-one spot puzzle)
            (map (lambda (lst) (quicksort lst (lambda (x y) (< (first x) (first y)))))
                 (map (lambda (num) (cons (list (first spot) num) 
                                          (filter (lambda (pair) (not (equal? pair spot))) (make-al puzzle)))) 
                      (possi-num spot puzzle))))
          ;; (neighbours puzzle) produces a list of puzzles that are formed after 
          ;;   the first empty spot is filled with valid sudoku digits
          ;; neighbours: Puzzle -> (listof Puzzle)
          (define (neighbours puzzle)
            (map (lambda (puzzle) 
                   (map (lambda (al) (map (lambda (pair) (second pair)) al)) puzzle)) 
                 (map (lambda (al) (recover al)) 
                      (replace-one (available-spot puzzle) puzzle))))]
    (find-final puzzle neighbours solved?)))

;; tests:
(check-expect (sudoku puzzle-surround) answer-to-surround)
(check-expect (sudoku puzzle-wrong) false)

(sudoku puzzle-surround)