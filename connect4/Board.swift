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

class Board: NSObject {
    
    // Number of spots per width and height
    static var width = 7
    static var height = 6
    
    var spots = [ChipColor]()
    
    var activePlayer:Player
    let player:Player = Player(chipColor: .red)
    let ai:Player = Player(chipColor: .yellow)
    
    override init() {
        // Initialize the Board with empty spaces
        for _ in 0 ..< Board.width * Board.height {
            self.spots.append(.none)
        }
        activePlayer = player
        super.init()
    }
    
    func swapTurn() {
        
        if activePlayer == player {
            activePlayer = ai
        } else {
            activePlayer = player
        }
    }
    
    func nextEmptyRow(at column: Int) -> Int? {
        for row in 0 ..< Board.height {
            let currChip = spots[row + column * Board.height]
            if currChip == .none {
                return row
            }
        }
        return nil
    }
    
    func add(chip: ChipColor, column:Int) {
        if let row = nextEmptyRow(at: column) {
            spots[row + column * Board.height] = chip
        }
    }
}
