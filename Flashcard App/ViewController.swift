//
//  ViewController.swift
//  Flashcard App
//
//  Created by Juan G. Partida on 4/10/22.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
    var extraAnswerOne: String
    var extraAnswerTwo: String
}

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    
    // Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    // Current flashcard index
    var currentIndex = 0
    
    // Button to remember what the correct answer is
    var correctAnswerButton: UIButton!
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Read saved flashcards
        readSavedFlashcards()
        
        // Adding  out initial flashcard if needed
        if flashcards.count == 0 {
           createBlankFlashcard()
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
        
        card.layer.cornerRadius = 15.0
        frontLabel.layer.cornerRadius = 15.0
        frontLabel.clipsToBounds = true
        backLabel.layer.cornerRadius = 15.0
        backLabel.clipsToBounds = true
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        btnOptionOne.layer.cornerRadius = 20
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        btnOptionTwo.layer.cornerRadius = 20
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        btnOptionThree.layer.cornerRadius = 20
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // First start with the flashcard invisible and slightly smaller in size
        card.alpha = 0.0
        btnOptionOne.alpha = 0.0
        btnOptionTwo.alpha = 0.0
        btnOptionThree.alpha = 0.0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionOne.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionTwo.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionThree.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        // Animation
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1.0
            self.btnOptionOne.alpha = 1.0
            self.btnOptionTwo.alpha = 1.0
            self.btnOptionThree.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
            self.btnOptionOne.transform = CGAffineTransform.identity
            self.btnOptionTwo.transform = CGAffineTransform.identity
            self.btnOptionThree.transform = CGAffineTransform.identity
        })
    }
    func createBlankFlashcard() {
        updateFlashcard(question: "Enter question", answer: "Enter answer", extraAnswerOne: "Extra answer one", extraAnswerTwo: "Extra answer two", isExisting: false)
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard() {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if(self.frontLabel.isHidden) {
                self.frontLabel.isHidden = false
            }
            else {
                self.frontLabel.isHidden = true
            }
        })
    }
    
    func animateCardOut(buttonType: String) {
        UIView.animate(withDuration: 0.3, animations: {
            if (buttonType == "next"){
                 self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
            } else {
                 self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
            }
        }, completion: { finished in
            
            // Update labels
            self.updateLabels()
            
            // Run other animation
            self.animateCardIn(buttonType: buttonType)
        })
    }
    
    func animateCardIn(buttonType: String) {
        
        // Start on the right side (don't animate this)
        if (buttonType == "next"){
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        } else {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }
        
        // Animate card going back to its original position
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func didTapBtnOptionOne(_ sender: Any) {
        // if correct answer flip flashcard, else disable button and show front label
        if btnOptionOne == correctAnswerButton {
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            btnOptionOne.isHidden = true
        }
    }
    
    @IBAction func didTapBtnOptionTwo(_ sender: Any) {
        if btnOptionTwo == correctAnswerButton {
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            btnOptionTwo.isHidden = true
        }
    }
    
    @IBAction func didTapBtnOptionThree(_ sender: Any) {
        if btnOptionThree == correctAnswerButton {
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            btnOptionThree.isHidden = true
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        // decrement current index
        currentIndex = currentIndex - 1
        
        // Update buttons
        updateNextPrevButtons()
        
        // animation
        animateCardOut(buttonType: "prev")
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        // Increase current index
        currentIndex = currentIndex + 1
        
        // Update buttons
        updateNextPrevButtons()
        
        // animation
        animateCardOut(buttonType: "next")
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        
        // Show confirmation
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String, extraAnswerTwo: String, isExisting: Bool) {
        
        let flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne, extraAnswerTwo: extraAnswerTwo)
        
        if isExisting {
            
            // Replace existing flashcard
            flashcards[currentIndex] = flashcard
            
        } else {
            
            // Adding flashcard in the flashcards array
            flashcards.append(flashcard)
            
            //Logging to the console
            print("😎 Added new flashcard")
            print("😎 We now have \(flashcards.count) flashcards")
            
            // Update current index
            currentIndex = flashcards.count - 1
            print("😎 Our current index is \(currentIndex)")
            
        }
        // Update buttons
        updateNextPrevButtons()
        
        // Update labels
        updateLabels()
        
        // Save all flashcards
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons() {
        
        // Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        // Disable prev button if at the end
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func deleteCurrentFlashcard() {
        
        // Delete current flashcard
        flashcards.remove(at: currentIndex)
        
        // Special case: cgeck if the last card was deleted
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1
        }
        
        // Special case:
        if currentIndex == -1 {
            
            // create blank flashcard
            createBlankFlashcard()
            
        }
        
        updateNextPrevButtons()
        
        updateLabels()
        
        saveAllFlashcardsToDisk()
    }
    
    func updateLabels() {
        
        // get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // unhide buttons and frontLabel
        if(self.frontLabel.isHidden) {
            self.frontLabel.isHidden = false
        }
        btnOptionOne.isHidden = false
        btnOptionTwo.isHidden = false
        btnOptionThree.isHidden = false
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
        
        
        // Update buttons
        let buttons = [btnOptionOne, btnOptionTwo, btnOptionThree].shuffled()
        let answers = [currentFlashcard.answer, currentFlashcard.extraAnswerOne, currentFlashcard.extraAnswerTwo].shuffled()
        
        for (button, answer) in zip(buttons, answers) {
            // set the title of this random button, with a random number
            button?.setTitle(answer, for:.normal)
            
            // If this is the cirrect answer save the button
            if answer == currentFlashcard.answer {
                correctAnswerButton = button
            }
        }
    }
    
    func saveAllFlashcardsToDisk() {
    
        // From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in return ["question": card.question, "answer": card.answer, "extraAnswerOne": card.extraAnswerOne, "extraAnswerTwo": card.extraAnswerTwo]
        }
        
        // Save array on siak using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // Log
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
      
        // Read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            
            // In here we know for sure we have a dictionary array
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extraAnswerOne: dictionary["extraAnswerOne"]!, extraAnswerTwo: dictionary["extraAnswerTwo"]!)
            }
            
            // Put all these cards in out flashcards array
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // We know the desitnation of the seque is the Navigation Controller
        let navigationController = segue.destination as! UINavigationController
        
        // We know the Navigation Controller only contains a Creation View Controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        // We set the flashcardsController property to self
        creationController.flashcardsController = self
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
        }
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



