//
//  Board.swift
//  connect4
//
//  Created by Laura Scully on 25/5/2017.
//  Copyright © 2017 laura.sempere.com. All rights reserved.
//

import Foundation

enum ChipColor: Int {
    case none = 0
    case red
    case yellow
}

enum Directions: Int {
    case horizontal = 0
    case vertical
    case diagonalUp
    case diagonalDown
}

class Board: NSObject {
    
    // Number of spots per width and height
    static var width = 7
    static var height = 6
    
    // Board spots are initialized with 'none' color, meaning empty spaces
    var spots:[[ChipColor]] = Array(repeating: Array(repeating: .none, count: width), count: height)
    
    var activePlayer:Player
    let player:Player
    let opponent:Player
    
    var winnerConnection:[Move] = []
    
    init(playerColor: ChipColor, gameMode:GameMode) {
        player = Player(chipColor: playerColor)
        let opponentColor:ChipColor = playerColor == .red ? .yellow : .red
        if gameMode == .onePlayer {
            opponent = Player(chipColor: opponentColor, ai: true)
        } else {
            opponent = Player(chipColor: opponentColor)
        }
        
        self.activePlayer = player
    }
    
    func reset() {
        spots = Array(repeating: Array(repeating: .none, count: Board.width), count: Board.height)
        activePlayer = player
        winnerConnection = []
    }
    
    func swapTurn() {
        
        if activePlayer == player {
            activePlayer = opponent
        } else {
            activePlayer = player
        }
    }
    
    func nextEmptyRow(at column: Int) -> Int? {
        for row in 0 ..< Board.height {
            let currChip = spots[row][column]
            if currChip == .none {
                return row
            }
        }
        return nil
    }
    
    func add(chip: ChipColor, column:Int) {
        if let row = nextEmptyRow(at: column) {
            spots[row][column] = chip
        }
    }
    
    
    private func horizontalConnection(for chip:ChipColor, row: Int, col: Int, connections: Int) ->  Bool {
        if col + connections > Board.width { return false }
        
        for i in 0 ..< connections {
            if spots[row][col + i] != chip {
                return false
            }
        }
        
        return true
    }
    
    private func verticalConnection(for chip:ChipColor, row: Int, col: Int, connections: Int) -> Bool {
        if row + connections > Board.height { return false }
        
        for i in 0 ..< connections {
            if spots[row + i][col] != chip {
                return false
            }
        }
        
        return true
    }
    
    private func diagonalPositiveConnection(for chip:ChipColor, row: Int, col: Int, connections: Int) -> Bool {
        if row + connections > Board.height { return false }
        if col + connections > Board.width { return false }
        
        for i in 0 ..< connections {
            if spots[row + i][col + i] != chip {
                return false
            }
        }
        
        return true
    }
    
    private func diagonalNegativeConnection(for chip:ChipColor, row: Int, col: Int, connections: Int) -> Bool {
        if row - (connections - 1) < 0 { return false }
        if col + connections > Board.width { return false }
        
        for i in 0 ..< connections {
            if spots[row - i][col + i] != chip {
                return false
            }
        }
        
        return true
    }
    
    private func createWinnerConnection(origin: Move, direction: Directions) {
        winnerConnection = []
        switch direction {
        case .horizontal:
           for i in 0 ..< 4 {
              winnerConnection.append(Move(column: origin.column + i, row: origin.row))
            }
        case .vertical:
            for i in 0 ..< 4 {
                winnerConnection.append(Move(column: origin.column, row: origin.row + i))
            }
        case .diagonalUp:
            for i in 0 ..< 4 {
                winnerConnection.append(Move(column: origin.column + i, row: origin.row + i))
            }
        case .diagonalDown:
            for i in 0 ..< 4 {
                winnerConnection.append(Move(column: origin.column + i, row: origin.row - i))
            }
        }
    }
    
    func isWinnerMove(for chip: ChipColor, row: Int, column: Int, connections: Int) -> Bool {
        if horizontalConnection(for: chip, row: row, col: column, connections: connections) {
            createWinnerConnection(origin: Move(column: column, row: row), direction: .horizontal)
            return true
        }
        if verticalConnection(for: chip, row: row, col: column, connections: connections) {
            createWinnerConnection(origin: Move(column: column, row: row), direction: .vertical)
            return true
        }
        if diagonalPositiveConnection(for: chip, row: row, col: column, connections: connections) {
            createWinnerConnection(origin: Move(column: column, row: row), direction: .diagonalUp)
            return true
        }
        if diagonalNegativeConnection(for: chip, row: row, col: column, connections: connections) {
            createWinnerConnection(origin: Move(column: column, row: row), direction: .diagonalDown)
            return true
        }
        return false
    }
    
    func isWinnerBoard(for chip:ChipColor, connections: Int) -> Bool {
        for row in 0 ..< Board.height {
            for column in 0 ..< Board.width {
                if isWinnerMove(for: chip, row: row, column: column, connections: connections) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func areMovesLeft() -> Bool{
        
        for row in 0 ..< Board.height {
            for col in 0 ..< Board.width {
                if spots[row][col] == .none {
                    return true
                }
            }
        }
        return false
    }
    
}



