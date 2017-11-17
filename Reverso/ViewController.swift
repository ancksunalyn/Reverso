//
//  ViewController.swift
//  Reverso
//
//  Created by Evelyn Andrade on 17-11-11.
//  Copyright © 2017 Evelyn Andrade. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btFrancais: UIButton!
    @IBOutlet weak var btEnglish: UIButton!
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var lbTraduction: UILabel!
    
    var arrOfFrenchWords: [String]!
    var arrOfEnglishWords: [String]!
    var dictOfWords: [String: String]!
    var sortedWords = [String]()
    
    var buttons: [UIButton]!
    var currentSelectedLanguage = "Français"

    @IBOutlet weak var lbnourriture: UILabel!
    
    let translation = UserDefaultsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [btFrancais, btEnglish]
        
        if translation.doesKeyExist(theKey: "frenchWords") {
            arrOfFrenchWords = translation.getValue(theKey: "frenchWords") as! [String]
            arrOfEnglishWords = translation.getValue(theKey: "englishWords") as! [String]
            dictOfWords = Dictionary(uniqueKeysWithValues: zip(arrOfFrenchWords, arrOfEnglishWords))
     
        } else {
            arrOfFrenchWords = [""]
            arrOfEnglishWords = [""]
            dictOfWords = ["": ""]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfFrenchWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        sortedWords = [String](dictOfWords.keys).sorted()
        cell.textLabel?.text = sortedWords[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lbTraduction.text = dictOfWords[sortedWords[indexPath.row]]
    }
    
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dictOfWords[sortedWords[indexPath.row]] = nil
            if currentSelectedLanguage == "Français" {
                arrOfFrenchWords = [String](dictOfWords.keys)
                arrOfEnglishWords = [String](dictOfWords.values)
            } else {
                arrOfFrenchWords = [String](dictOfWords.values)
                arrOfEnglishWords = [String](dictOfWords.keys)
            }
            sortedWords = [String](dictOfWords.keys).sorted()
            translation.setKey(theValue: arrOfFrenchWords as AnyObject, theKey: "frenchWords")
            translation.setKey(theValue: arrOfEnglishWords as AnyObject, theKey: "englishWords")
            lbTraduction.text = ""
            tabView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }

    
    @IBAction func changeLanguagesDirection(_ sender: UIButton) {
        if currentSelectedLanguage == "Français" {
            btFrancais.setTitle("English", for: .normal)
            btEnglish.setTitle("Français", for: .normal)
            dictOfWords = Dictionary(uniqueKeysWithValues: zip(arrOfEnglishWords, arrOfFrenchWords))
            tabView.reloadData()
            currentSelectedLanguage = "English"
        } else {
            btFrancais.setTitle("Français", for: .normal)
            btEnglish.setTitle("English", for: .normal)
            dictOfWords = Dictionary(uniqueKeysWithValues: zip(arrOfFrenchWords, arrOfEnglishWords))
            tabView.reloadData()
            currentSelectedLanguage = "Français"
        }
        lbTraduction.text = ""
        btFrancais.alpha = 1.0
        btEnglish.alpha = 0.5
    }
}

