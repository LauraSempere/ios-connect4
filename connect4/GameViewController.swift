//
//  GameViewController.swift
//  connect4
//
//  Created by Laura Scully on 25/5/2017.
//  Copyright © 2017 laura.sempere.com. All rights reserved.
//

import UIKit
import AVFoundation

enum GameMode {
    case onePlayer
    case twoPlayers
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameBoard: UIStackView!
    @IBOutlet var columnViews: [UIView]!
    @IBOutlet var columnButtons: [UIButton]!
    
    @IBOutlet weak var currentTurnImageView: UIImageView!
    @IBOutlet weak var currentTurnLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer?
    
    var selectedColor:ChipColor = .red
    var gameMode:GameMode = .onePlayer
    var board:Board!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        board = Board(playerColor: selectedColor, gameMode: gameMode)
        displayCurrentTurn()
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.makeAIMove(move: move)
            })
            
        }
        
    }
    
    func newGame() {
        board.reset()
        // Clear all the chips from the view
        let chipImageViews = self.view.subviews.filter{$0.tag == 99}
        for chipImageView in chipImageViews {
            chipImageView.removeFromSuperview()
        }
        displayCurrentTurn()
        // Remove the winning line indicator from the view
        view.viewWithTag(100)?.removeFromSuperview()
        toggleColumnInteration(active: true)
    }
    
    private func updateGame() {
        
        if board.isWinnerBoard(for: board.activePlayer.chip, connections: 4) {
            toggleColumnInteration(active: false)
            displayWinnerAlert(winner: board.activePlayer)
        } else  {
            board.swapTurn()
            
            if board.activePlayer === board.opponent && (board.opponent.ai != nil) {
                toggleColumnInteration(active: false)
                initAIMove()
            } else {
                toggleColumnInteration(active: true)
            }
            
        }
        
    }
    
    // User interaction
    @IBAction func columnButtonDidTap(_ sender: UIButton) {
        toggleColumnInteration(active: false)
        
        if let row =  board.nextEmptyRow(at: sender.tag) {
            board.add(chip: board.activePlayer.chip, column: sender.tag)
            displayChip(imageFor(chipColor: board.activePlayer.chip)!, at: sender.tag, row: row)
            updateGame()
            
        }
    }
    
}

// MARK: Utils extension

extension GameViewController {
    
    func displayCurrentTurn() {
        
        currentTurnImageView.image = imageFor(chipColor: board.activePlayer.chip)
        
        if gameMode == .onePlayer {
            currentTurnLabel.text = board.activePlayer === board.player ? "Your Turn" : "Computer's Turn"
        } else {
            
            currentTurnLabel.text = board.activePlayer === board.player ? "Player 1 Turn" : "Player 2 Turn"
        }
        
    }
    
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
        
        // Chip Animation in with completion handler
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            chip.transform = CGAffineTransform.identity
        }) { (completed) in
            if completed {
                self.playSound()
                if self.board.winnerConnection.count == 4 {
                    self.showWinningPath()
                }
                self.displayCurrentTurn()
            }
        }
        
    }
    
    func getCGPoint(for move: Move) -> CGPoint {
        let chipSize = max(gameBoard.frame.width / CGFloat(Board.width), gameBoard.frame.height / CGFloat(Board.height))
        let columnView = columnViews[move.column]
        let x = columnView.frame.midX + gameBoard.frame.minX
        var y = columnView.frame.maxY - chipSize / 2 + gameBoard.frame.minY
        y -= chipSize * CGFloat(move.row)
        
        return CGPoint(x: x, y: y)
    }
    
    func showWinningPath() {
        let initialPoint = getCGPoint(for: board.winnerConnection.first!)
        let finalPoint = getCGPoint(for: board.winnerConnection.last!)
        
        let path = UIBezierPath()
        path.move(to: initialPoint)
        path.addLine(to: finalPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.cyan.cgColor
        shapeLayer.strokeColor = UIColor.cyan.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.path = path.cgPath
        let pathView = UIView(frame: view.frame)
        pathView.tag = 100
        
        pathView.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.5
        shapeLayer.add(animation, forKey: "MyAnimation")
        
        view.addSubview(pathView)
        
        
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
        
        var title = ""
        var message = ""
        
        if gameMode == .onePlayer {
            title = winner === board.player ? "Congratulations!" : "You lose!"
            message = winner === board.player ? "You won the game" : "Keep it up and try again"
        } else {
            title = "Game Over"
            message = "Player \(String(describing: winner.chip).capitalized) wins!"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let playAgainAction = UIAlertAction(title: "Play Again", style: .default) { _ in
                self.newGame()
            }
            
            let exitAgainAction = UIAlertAction(title: "Exit", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            alert.addAction(playAgainAction)
            alert.addAction(exitAgainAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func playSound() {
        guard let sound = NSDataAsset(name: "whoop") else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            
            audioPlayer!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
}
