//
//  StartScreenViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {
    let gameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.text = "HANGMAN"
        label.textAlignment = .center
        label.font = UIFont(name: "courier", size: 50)
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("START", for: .normal)
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    func setupUI() {
        // setup title
        self.view.addSubview(gameTitle)
        gameTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        gameTitle.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
        gameTitle.heightAnchor.constraint(equalToConstant: 200).isActive = true
        gameTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -50).isActive = true
        
        // setup button
        self.view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(handleStartGame), for: .touchUpInside)
        startButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        startButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func handleStartGame() {
        let vc = GameViewController()
        self.present(vc, animated: true, completion: nil)
    }
}
