//
//  CreationViewController.swift
//  Flashcard App
//
//  Created by Juan G. Partida on 4/10/22.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!

    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var extraAnswerOne: UITextField!
    @IBOutlet weak var extraAnswerTwo: UITextField!
    
    
    var initialQuestion: String?
    var initialAnswer: String?
    
    //see if it's existing

    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
         dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        
        // Get the text in the question text field
        let questionText = questionTextField.text
        
        // Get the Text in the answer text field
        let answerText = answerTextField.text
        
        // Get the Text in the extra answer one text field
        let extraAnswerOneText = extraAnswerOne.text
        
        // Get the Text in the extra answer two text field
        let extraAnswerTwoText = extraAnswerTwo.text
        
        // Alert for missing text for question and answers
        let alert = UIAlertController(title: "Missing text", message: "You need to enter both a question and an answer", preferredStyle: .alert)
        
        // Ok action for alert
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        
        // Check if question and answers text fields are empty
        if (questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty) {
            present(alert, animated: true)
        }
        else {
            var isExisting = false
            if initialQuestion != nil {
                isExisting = true
            }
            // Call the function to update the flashcard
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!, extraAnswerOne: extraAnswerOneText!, extraAnswerTwo: extraAnswerTwoText!, isExisting: isExisting)
            
            // Dismiss
            dismiss(animated: true)
        }
        
    }
}
