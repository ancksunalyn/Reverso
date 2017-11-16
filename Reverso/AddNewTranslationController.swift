//
//  AddNewTranslationController.swift
//  Reverso
//
//  Created by Evelyn Andrade on 17-11-11.
//  Copyright © 2017 Evelyn Andrade. All rights reserved.
//

import UIKit

class AddNewTranslationController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newFrenchWord: UITextField!
    @IBOutlet weak var newEnglishWord: UITextField!
    @IBOutlet weak var lbMessages: UILabel!
    
    var arrOfFrenchWords: [String]!
    var arrOfEnglishWords: [String]!
    let translation = UserDefaultsManager()
    var existentWord = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newFrenchWord.becomeFirstResponder()
        if translation.doesKeyExist(theKey: "frenchWords") {
            arrOfFrenchWords = translation.getValue(theKey: "frenchWords") as! [String]
            arrOfEnglishWords = translation.getValue(theKey: "englishWords") as! [String]
        } else {
            arrOfFrenchWords = [""]
            arrOfEnglishWords = [""]
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        newFrenchWord.resignFirstResponder()
        newEnglishWord.resignFirstResponder()
        return true
    }
    
    @IBAction func saveWord (_ sender: UIButton) {
        if (newFrenchWord.text != "") && (newEnglishWord.text != "") {
            if arrOfFrenchWords[0] == "" {
                    arrOfFrenchWords = [newFrenchWord.text!]
                    arrOfEnglishWords = [newEnglishWord.text!]
                translation.setKey(theValue: arrOfFrenchWords as AnyObject, theKey: "frenchWords")
                translation.setKey(theValue: arrOfEnglishWords as AnyObject, theKey: "englishWords")
                newFrenchWord.text = ""
                newEnglishWord.text = ""
                lbMessages.text = "Les mots ont été sauvegardés!"
            } else {
                for i in 0...arrOfFrenchWords.count-1 {
                    if (arrOfFrenchWords[i] == newFrenchWord.text!) || (arrOfEnglishWords[i] == newEnglishWord.text!) {
                        existentWord = arrOfFrenchWords[i]
                    }
                }
                if existentWord != "" {
                    let alertController = UIAlertController(title: "Message", message: "Ce mot est dèjà registré! Entrez un nouveau mot!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        self.newFrenchWord.text! = ""
                        self.newFrenchWord.becomeFirstResponder()
                        self.newEnglishWord.text! = ""
                        self.lbMessages.text! = ""
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    arrOfFrenchWords.append(newFrenchWord.text!)
                    arrOfEnglishWords.append(newEnglishWord.text!)
                    translation.setKey(theValue: arrOfFrenchWords as AnyObject, theKey: "frenchWords")
                    translation.setKey(theValue: arrOfEnglishWords as AnyObject, theKey: "englishWords")
                    newFrenchWord.text = ""
                    newEnglishWord.text = ""
                    lbMessages.text = "Les mots ont été sauvegardés!"
                }
                
            }
            
        } else {
            lbMessages.text = "Entrez les deux mots!"
        }
    }
}
