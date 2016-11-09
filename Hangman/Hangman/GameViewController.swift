//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {
    var currentPhrase: String?
    let NUMBER_OF_ALLOWED_WRONGS = 6
    var hangmanImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var textField: UITextField = {
        let field = UITextField()
        field.becomeFirstResponder()
        return field
    }()
    
    var wrongGuesses:UILabel = {
        let label = UILabel()
        label.text = "Wrong Guesses:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var guessField: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.font = UIFont(name: "courier", size: 20)
        return label
    }()
    
    var boxes: [UILabel] = []
    var numberOfWrongs = 0
    var incorrectGuesses: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        //self.currentPhrase = hangmanPhrases
        self.view.addSubview(textField)
        textField.delegate = self
        resetGame()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.guessField.text = string.capitalized
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let c = (self.guessField.text?.characters.first)!
        self.guessField.text = nil
        if self.contains(character: c) {
            show(character: c)
            
        } else {
            wrong(character: c)
        }
        return true
    }
    
    func resetGame() {
        let hangmanPhrases = HangmanPhrases()
        self.currentPhrase = hangmanPhrases.getRandomPhrase()
        self.numberOfWrongs = 0
        self.guessField.text = nil
        self.wrongGuesses.text = "Wrong Guesses:"
        updateImage(numberOfWrongs: 0)
        setupUI()
        removeBoxes()
        generateBoxes()
        hideWords()
    }
    
    func setupUI() {
        // image setup
        self.view.addSubview(hangmanImage)
        hangmanImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        hangmanImage.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        hangmanImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        hangmanImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        
        // wrong guesses
        self.view.addSubview(wrongGuesses)
        wrongGuesses.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -30).isActive = true
        wrongGuesses.heightAnchor.constraint(equalToConstant: 30).isActive = true
        wrongGuesses.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
        wrongGuesses.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        // text field
        self.view.addSubview(guessField)
        guessField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        guessField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        guessField.topAnchor.constraint(equalTo: hangmanImage.bottomAnchor, constant: 10).isActive = true
        guessField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //
        
    }

    func removeBoxes() {
        for view in self.view.subviews {
            if view.tag == 111 {
                view.removeFromSuperview()
            }
        }
        
        self.boxes = []
    }
    
    func generateBoxes() {
        
        
        var xCoordinate = CGFloat(floatLiteral: 10.0)
        var yCoordinate = UIScreen.main.bounds.size.height/2 - 80.0
        for c in (self.currentPhrase?.characters)! {
            let label:UILabel = {
                let line = UIView(frame: CGRect(x: 0, y: 30, width: 20, height: 1))
                line.backgroundColor = UIColor.black
                
                let label = UILabel(frame: CGRect(x: xCoordinate, y: yCoordinate, width: 20, height: 30))
                label.text = "\(c)"
                if c != " " {
                    label.addSubview(line)
                }
                label.font = UIFont(name: "courier", size: 25)
                label.textAlignment = .center
                label.textColor = UIColor.black
                label.tag = 111
                
                return label
            }()
            
            self.view.addSubview(label)
            
            self.boxes.append(label)
            xCoordinate += 25
            if xCoordinate + 20 > UIScreen.main.bounds.size.width {
                xCoordinate = CGFloat(floatLiteral: 10.0)
                yCoordinate += 40
            }
            
            
        }
    }
    
    func hideWords() {
        for label in boxes {
            label.textColor = UIColor.clear
        }
    }
    
    func contains(character: Character) -> Bool {
        for label in boxes {
            if label.text == "\(character)" {
                return true
            }
        }
        return false
    }
    
    func show(character: Character) {
        for label in boxes {
            if label.text == "\(character)" {
                label.textColor = UIColor.black
            }
        }
        
        if didWin() {
            let alertView = UIAlertController(title: "Congratulation! You Won!", message: "The phrase was \(currentPhrase!)", preferredStyle: .alert)
            let startOver = UIAlertAction(title: "Start Over", style: .default) { (action) in
                self.resetGame()
            }
            alertView.addAction(startOver)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func didWin() -> Bool {
        for label in boxes {
            if label.textColor != UIColor.clear {
                return false
            }
        }
        return true
    }
    
    func wrong(character: Character) {
        if numberOfWrongs == 0 {
            wrongGuesses.text?.append(" \(character)")
        } else {
            wrongGuesses.text?.append(", \(character)")
        }
        numberOfWrongs = numberOfWrongs + 1
        
        
        if numberOfWrongs == NUMBER_OF_ALLOWED_WRONGS {
            endGame()
        }
        
        updateImage(numberOfWrongs: numberOfWrongs)
    }
    
    func endGame() {
        let alertView = UIAlertController(title: "You Lost!", message: "The phrase was \(currentPhrase!)", preferredStyle: .alert)
        let startOver = UIAlertAction(title: "Start Over", style: .default) { (action) in
            self.resetGame()
        }
        alertView.addAction(startOver)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func updateImage(numberOfWrongs: Int) {
        let imageName = "hangman\(numberOfWrongs+1).gif"
        hangmanImage.image = UIImage(named: imageName)
    }
}


