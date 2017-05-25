//
//  GameViewController.swift
//  connect4
//
//  Created by Laura Scully on 25/5/2017.
//  Copyright © 2017 laura.sempere.com. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var columnButtons: [UIButton]!
    @IBOutlet weak var gameBoard: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func columnButtonDidTap(_ sender: UIButton) {
        print("Button in Column Tapped! \(sender.tag)")
    }


}
