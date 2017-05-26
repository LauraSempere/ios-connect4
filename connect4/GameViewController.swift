//
//  GameViewController.swift
//  connect4
//
//  Created by Laura Scully on 25/5/2017.
//  Copyright © 2017 laura.sempere.com. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameBoard: UIStackView!
    @IBOutlet var columnViews: [UIView]!
    @IBOutlet var columnButtons: [UIButton]!
    
    var board = Board()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func toggleColumnInteration(active: Bool) {
        for button in columnButtons {
            button.isUserInteractionEnabled = active
        }
    }
    
    private func imageFor(chipColor: ChipColor) -> UIImage? {
        switch chipColor {
        case .red: return UIImage(named: "redChip")!
        case .yellow: return UIImage(named: "yellowChip")!
        default: return nil
        }
    }
    
    
    private func updateGame() {
        
        if board.activePlayer == board.player {
            toggleColumnInteration(active: true)
            
        } else {
            toggleColumnInteration(active: false)
            
            let move = board.activePlayer.randomMove(for: board)
            board.add(chip: board.activePlayer.chip, column: move.column)
            
            // AI player move shows after 2 seconds on the screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [unowned self] in
                self.displayChip(self.imageFor(chipColor: self.board.activePlayer.chip)!, at: move.column, row: move.row)
                self.board.swapTurn()
                // Recursion to achieve the game loop
                self.updateGame()
            })
            
            
        }
    }
    
    @IBAction func columnButtonDidTap(_ sender: UIButton) {
        
        if let row =  board.nextEmptyRow(at: sender.tag) {
            board.add(chip: board.activePlayer.chip, column: sender.tag)
            displayChip(imageFor(chipColor: board.activePlayer.chip)!, at: sender.tag, row: row)
            
            board.swapTurn()
            updateGame()
        }
        
    }
    
    func displayChip(_ chipImage: UIImage, at column:Int, row: Int) {
        
        let offSet:CGFloat = 2
        let columnView = columnViews[column]
        let chipSize = max(columnView.frame.width - offSet, columnView.frame.height / 6)
        let chipFrame = CGRect(x: 0, y: 0, width: chipSize, height: chipSize)
        
        let chip = UIImageView()
        chip.image = chipImage
        chip.frame = chipFrame
        chip.contentMode = .scaleAspectFit
        
        let x = columnView.frame.midX + gameBoard.frame.minX
        var y = columnView.frame.maxY - chipSize / 2 + gameBoard.frame.minY
        y -= chipSize * CGFloat(row)
        
        chip.center = CGPoint(x: x, y: y)
        
        // Initial position of the chip out of the view
        chip.transform = CGAffineTransform(translationX: 0, y: -800)
        
        view.addSubview(chip)
        
        // Chip Animation in
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseIn, animations: {
            chip.transform = CGAffineTransform.identity
        })
        
    }
    
    
}
