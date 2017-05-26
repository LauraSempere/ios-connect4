//
//  Move.swift
//  connect4
//
//  Created by Laura Scully on 26/5/2017.
//  Copyright © 2017 laura.sempere.com. All rights reserved.
//

import Foundation

struct Move {
    var column:Int
    var row:Int
    
    init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }

}
