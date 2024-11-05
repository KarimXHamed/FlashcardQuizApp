//
//  QuizViewController.swift
//  flashCardApp
//
//  Created by karim hamed ashour on 10/8/24.
//

import UIKit

class QuizViewController: UIViewController,UITextFieldDelegate {
    var flashCards=[Quiz]()
    var addButton:UIBarButtonItem!
    @IBOutlet weak var scoreLabel: UILabel!
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    var viewController:ViewController?
    var currentIndex=0
    var currrentQuestion:String?
    var currrentAnswer:String?
    var maxScore:Int?
    var savedQuizes:[Quiz]?=[]
    var currentCategory:String?
    var score = 0 {
        didSet{
            
            self.scoreLabel.text="score=\(self.score)/\(self.maxScore!*10)"}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: currentCategory!) {
            if let decodedQuizes = try? JSONDecoder().decode([Quiz].self, from: data) {
                savedQuizes = decodedQuizes
                print("retrieved")
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
       navigationItem.rightBarButtonItem = addButton
        
        scoreLabel.layer.cornerRadius = 25
        scoreLabel.layer.masksToBounds = true
        scoreLabel.text="score=\(score)/\(self.score*10)"
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 25).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 50
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        setUpUI()
        
        
      
        
        
    }
    func setUpUI(){
        if let savedQuizes=savedQuizes{
            flashCards=flashCards+savedQuizes
       }
        for flashcard in flashCards {
            
            let quiz = FlashCard()
            quiz.delegate=self
            quiz.textLabel.text=flashcard.question.text
            quiz.frontText = flashcard.question.text
            quiz.backText = flashcard.correctAnswer
            quiz.correctAnswer = flashcard.correctAnswer
            quiz.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(quiz)
            
            quiz.widthAnchor.constraint(equalToConstant: 250).isActive = true
            quiz.heightAnchor.constraint(equalToConstant: 250).isActive = true
            quiz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70).isActive = true
            quiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70).isActive = true
            
            
        }
        maxScore=flashCards.count
      scoreLabel.text="score=\(self.score)/\(self.maxScore!*10)"
    }
    func updateUI(newFlashCard:Quiz){
        let quiz = FlashCard()
        quiz.delegate=self
        quiz.textLabel.text=newFlashCard.question.text
        quiz.frontText = newFlashCard.question.text
        quiz.backText = newFlashCard.correctAnswer
        quiz.correctAnswer = newFlashCard.correctAnswer
        quiz.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(quiz)
        
        quiz.widthAnchor.constraint(equalToConstant: 250).isActive = true
        quiz.heightAnchor.constraint(equalToConstant: 250).isActive = true
        quiz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70).isActive = true
        quiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70).isActive = true
        
        let lastFlashCardIndex = stackView.arrangedSubviews.count - 1
        if lastFlashCardIndex >= 0 {
            let lastFlashCard = stackView.arrangedSubviews[lastFlashCardIndex]
            scrollView.scrollRectToVisible(lastFlashCard.frame, animated: true)
        }

    maxScore=flashCards.count
  scoreLabel.text="score=\(self.score)/\(self.maxScore!*10)"
}


    
    func updateScore(by points:Int){
        score+=points
        
    }
    @objc func addButtonTapped(){
       

            let alertController = UIAlertController(title: "Enter Question/Answer", message: nil, preferredStyle: .alert)
            alertController.addTextField{textField in
                textField.placeholder="Enter Question"
                
            }
        alertController.addTextField{textField in
            textField.placeholder="Enter Answer"
            
        }
            let action = UIAlertAction(title: "Add", style: .default) {[weak self] _ in
                if let questionTextField = alertController.textFields?.first , let text1 = questionTextField.text{
                    self?.currrentQuestion=text1
                }
                if let answerTextField = alertController.textFields?[1] , let text2 = answerTextField.text{
                    self?.currrentAnswer=text2
                }
                let newQuestion=Quiz(correctAnswer: self?.currrentAnswer! ?? "", question: Question(text: self?.currrentQuestion! ?? "") , category: self?.currentCategory! ?? "")
                                     
                self?.viewController?.quizes[self!.currentIndex].append(newQuestion)
                self?.flashCards.append(newQuestion)
                self?.savedQuizes?.append(newQuestion)
                print("appended")
                let defaults = UserDefaults.standard
                if let savedQuizes = self!.savedQuizes {
                    if let encoded = try? JSONEncoder().encode(savedQuizes) {
                        defaults.set(encoded, forKey: self?.currentCategory! ?? "")
                        print("saved")
                    }
                }
                self?.updateUI(newFlashCard: newQuestion)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(action)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            // Scroll to the last flashcard if needed
            let lastFlashCardIndex = stackView.arrangedSubviews.count - 1
            if lastFlashCardIndex >= 0 {
                let lastFlashCard = stackView.arrangedSubviews[lastFlashCardIndex]
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
 

       @objc func dismissKeyboard() {
           view.endEditing(true) // Dismiss the keyboard
       }


    }
