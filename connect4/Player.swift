//
//  Player.swift
//  connect4
//
//  Created by Laura Scully on 26/5/2017.
//  Copyright © 2017 laura.sempere.com. All rights reserved.
//

import Foundation

class Player: NSObject {

    var chip:ChipColor
    
    init(chipColor:ChipColor) {
       self.chip = chipColor
    }
    
    func randomMove(for board: Board) -> Move {
        let column = Int(arc4random_uniform(7))
        if let row = board.nextEmptyRow(at: column) {
          return Move(column: column, row: row)
        } else {
            return randomMove(for: board)
        }
    }
}
