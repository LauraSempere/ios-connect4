//
//  connect4Tests.swift
//  connect4Tests
//
//  Created by Laura Scully on 29/5/2017.
//  Copyright © 2017 laura.sempere.com. All rights reserved.
//

import XCTest
@testable import connect4

class connect4Tests: XCTestCase {
    
    var onePlayerBoard:Board!
    
    override func setUp() {
        super.setUp()
        onePlayerBoard = Board(playerColor: .red, gameMode: .onePlayer)
        
        // Mockup one possible state of the board after several turns (The rest of the spots are empty)
        onePlayerBoard.spots[0][0] = .red
        onePlayerBoard.spots[0][1] = .red
        onePlayerBoard.spots[0][2] = .red
        onePlayerBoard.spots[1][0] = .yellow
        onePlayerBoard.spots[1][1] = .yellow
        onePlayerBoard.spots[1][2] = .yellow
        
    }
    
    func testPlayerRedWins() {
        // The player red is going to place a chip on the spot [0][3]
        onePlayerBoard.add(chip: .red, column: 3)
        XCTAssertTrue(onePlayerBoard.isWinnerBoard(for: .red, connections: 4))
    }
    
    func testPlayerYellowDoesNotWin() {
        // The player yellow is going to place a chip on the spot [0][3]
        onePlayerBoard.add(chip: .yellow, column: 3)
        XCTAssertFalse(onePlayerBoard.isWinnerBoard(for: .yellow, connections: 4))
    }
    
    func testSwapTurn() {
        onePlayerBoard.swapTurn()
        XCTAssertTrue(onePlayerBoard.activePlayer === onePlayerBoard.opponent)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
}


