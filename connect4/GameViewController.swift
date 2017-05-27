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
    
    
    // MARK: Game lifecycle functions
    
    private func makeAIMove(move: Move) {
        board.add(chip: board.activePlayer.chip, column: move.column)
        displayChip(imageFor(chipColor: board.activePlayer.chip)!, at: move.column, row: move.row)
        updateGame()
    }
    
    private func initAIMove() {
        var move:Move
        
        if let ai = board.activePlayer.ai {
            if let bestMove = ai.findBestMove(for: board) {
                move = bestMove
            } else {
                move = board.activePlayer.randomMove(for: board)
            
            }
            self.makeAIMove(move: move)
        }
        
    }
    
    func newGame() {
        board.reset()
        let chipImageViews = self.view.subviews.filter{$0.tag == 99}
        for chipImageView in chipImageViews {
            chipImageView.removeFromSuperview()
        }
        toggleColumnInteration(active: true)
    }
    
    private func updateGame() {
        
        if board.isWinnerBoard(for: board.activePlayer.chip, connections: 4) {
            toggleColumnInteration(active: false)
            displayWinnerAlert(winner: board.activePlayer)
        } else  {
            board.swapTurn()
            
            if board.activePlayer === board.player {
                toggleColumnInteration(active: true)
                
            } else {
                toggleColumnInteration(active: false)
                initAIMove()
                
            }
        }
        
    }
    
    // User interaction
    @IBAction func columnButtonDidTap(_ sender: UIButton) {
        
        if let row =  board.nextEmptyRow(at: sender.tag) {
            board.add(chip: board.activePlayer.chip, column: sender.tag)
            displayChip(imageFor(chipColor: board.activePlayer.chip)!, at: sender.tag, row: row)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.updateGame()
            })
            
        }
    }
    
}

// MARK: Utils extension

extension GameViewController {
    
    func displayChip(_ chipImage: UIImage, at column:Int, row: Int) {
        
        let offSet:CGFloat = 2
        let columnView = columnViews[column]
        let chipSize = max(columnView.frame.width - offSet, columnView.frame.height / 6)
        let chipFrame = CGRect(x: 0, y: 0, width: chipSize, height: chipSize)
        
        let chip = UIImageView()
        chip.tag = 99
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
    
    func toggleColumnInteration(active: Bool) {
        for button in columnButtons {
            button.isUserInteractionEnabled = active
        }
    }
    
     func imageFor(chipColor: ChipColor) -> UIImage? {
        switch chipColor {
        case .red: return UIImage(named: "redChip")!
        case .yellow: return UIImage(named: "yellowChip")!
        default: return nil
        }
    }
    
    func displayWinnerAlert(winner: Player) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let alert = UIAlertController(title: "Game Over", message: "The player \(winner.chip) has won!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Play Again", style: .default) { _ in
                self.newGame()
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}
