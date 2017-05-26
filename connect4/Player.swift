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
}
