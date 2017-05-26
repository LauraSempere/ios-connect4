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
    
    var board = Board()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func imageFor(chipColor: ChipColor) -> UIImage? {
        switch chipColor {
        case .red: return UIImage(named: "redChip")!
        case .yellow: return UIImage(named: "yellowChip")!
        default: return nil
        }
    }
    

    @IBAction func columnButtonDidTap(_ sender: UIButton) {
        print("Button in Column Tapped! \(sender.tag)")
        if let row =  board.nextEmptyRow(at: sender.tag) {
            board.add(chip: board.activeChip, column: sender.tag)
            displayChip(imageFor(chipColor: board.activeChip)!, at: sender.tag, row: row)
            
            board.swapTurn()
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
