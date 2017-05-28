//
//  SelectColorViewController.swift
//  connect4
//
//  Created by Laura Scully on 27/5/2017.
//  Copyright © 2017 laura.sempere.com. All rights reserved.
//

import UIKit

class SelectColorViewController: UIViewController {
    
    @IBOutlet var colorButtons:[UIImageView]!
    @IBOutlet var gameModeButtons: [UILabel]!
    var colorSelected:ChipColor = .red
    var gameMode: GameMode = .onePlayer

    override func viewDidLoad() {
        super.viewDidLoad()
        for colorButton in colorButtons {
            colorButton.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectColor(sender:)))
            colorButton.addGestureRecognizer(tapGesture)
        }
        
        for gameModeButton in gameModeButtons {
            gameModeButton.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectGameMode(sender:)))
            gameModeButton.addGestureRecognizer(tapGesture)
        }

    }

    func selectColor(sender: UITapGestureRecognizer) {
        
        if let tag = sender.view?.tag {
            if tag == 11 {
                self.view.viewWithTag(11)?.backgroundColor = UIColor.cyan
                self.view.viewWithTag(22)?.backgroundColor = UIColor.clear
                colorSelected = .red
            } else if tag == 22 {
                self.view.viewWithTag(11)?.backgroundColor = UIColor.clear
                self.view.viewWithTag(22)?.backgroundColor = UIColor.cyan
                colorSelected = .yellow
            }
        }
    
    }
    
    func selectGameMode(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            if tag == 33 {
                self.view.viewWithTag(33)?.backgroundColor = UIColor.cyan
                self.view.viewWithTag(44)?.backgroundColor = UIColor.clear
                gameMode = .onePlayer
            } else if tag == 44 {
                self.view.viewWithTag(33)?.backgroundColor = UIColor.clear
                self.view.viewWithTag(44)?.backgroundColor = UIColor.cyan
                gameMode = .twoPlayers
            }
        }

    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameVC = segue.destination as! GameViewController
        gameVC.selectedColor = colorSelected
        gameVC.gameMode = gameMode

    }
 

}
