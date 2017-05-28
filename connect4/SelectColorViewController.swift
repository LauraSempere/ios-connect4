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
    
    var colorSelected:ChipColor = .red

    override func viewDidLoad() {
        super.viewDidLoad()
        for colorButton in colorButtons {
            colorButton.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectColor(sender:)))
            colorButton.addGestureRecognizer(tapGesture)
        }

    }
    
    private func toggleColorSelector(selected: Int) {
        if selected == 11 {
            self.view.viewWithTag(11)?.backgroundColor = UIColor.cyan
            self.view.viewWithTag(22)?.backgroundColor = UIColor.clear
            colorSelected = .red
        } else if selected == 22 {
            self.view.viewWithTag(11)?.backgroundColor = UIColor.clear
            self.view.viewWithTag(22)?.backgroundColor = UIColor.cyan
            colorSelected = .yellow
        }
    }

    func selectColor(sender: UITapGestureRecognizer) {
        toggleColorSelector(selected: (sender.view?.tag)!)
    
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameVC = segue.destination as! GameViewController
        gameVC.selectedColor = colorSelected

    }
 

}
