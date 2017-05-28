//
//  AI.swift
//  connect4
//
//  Created by Laura Scully on 27/5/2017.
//  Copyright © 2017 laura.sempere.com. All rights reserved.
//

import Foundation

class AI: NSObject {
    
    static let depth = 2
    
    func score(for board: Board) -> Int {
        
        if board.activePlayer === board.player {
            if board.isWinnerBoard(for: board.activePlayer.chip, connections: 4){
                return 10
            }
            
            
        } else if board.activePlayer === board.opponent {
            if board.isWinnerBoard(for: board.activePlayer.chip, connections: 4) {
                return -10
            }
            
        }
        
        return 0
    }
    
    func minimaxStrategy(board: Board, depth: Int, isMax: Bool) -> Int {
        
        let scr = score(for: board)
        
        if depth == 0 {
            return 0
        }
        
        if scr == 10 || scr == -10 {
            return scr
        }
        // No more moves are available. The game is a tie
        if board.areMovesLeft() == false {
            return 0
        }
        
        // If the Player is the Maximizer
        if isMax {
            // Initial value is the worst value for a maximizer player
            var bestScore = -10000
            
            for col in 0 ..< Board.width {
                
                if let row = board.nextEmptyRow(at: col) {
                    board.spots[row][col] = board.activePlayer.chip
                    board.swapTurn()
                    
                    bestScore = max(bestScore, minimaxStrategy(board: board, depth: depth - 1, isMax: !isMax))
                    
                    // Undo the move
                    board.spots[row][col] = .none
                    
                }
            }
            
            return bestScore
            
        }
        // Case when the player is the Minimizer
        else {
            
            // Initial value is the worst value for a minimizer player
            var bestScore = 10000
            
            for col in 0 ..< Board.width {
                if let row = board.nextEmptyRow(at: col) {
                    board.spots[row][col] = board.activePlayer.chip
                    
                    board.swapTurn()
                    bestScore = min(bestScore, minimaxStrategy(board: board, depth: depth - 1, isMax: !isMax))
                    
                    // Undo the move
                    board.spots[row][col] = .none
                }
            }
            
            return bestScore
            
        }
        
    }
    
    func findBestMove(for board: Board) -> Move? {
        var bestScore = 0
        var bestMove:Move
        
        // We create a new instance of Board and copy the spots from the original to do all the simulations
        let boardCopy = Board(playerColor: board.player.chip, gameMode: .onePlayer)
        boardCopy.spots = board.spots
        
        for col in 0 ..< Board.width {
            if let row = boardCopy.nextEmptyRow(at: col) {
                
                boardCopy.spots[row][col] = boardCopy.activePlayer.chip
                let moveScore = minimaxStrategy(board: boardCopy, depth: AI.depth, isMax: false)
                
                if moveScore != bestScore {
                    bestMove = Move(column: col, row: row)
                    bestScore = moveScore
                    
                    return bestMove
                }
            }
        }
        
        return nil
    }
    
}
