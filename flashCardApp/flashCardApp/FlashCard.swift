import UIKit

class FlashCard: UIView, UITextFieldDelegate {
    var isFlipped=false
    var frontText="???"
    var backText="???"
    
    @IBOutlet weak var flashCardLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var FlashCardTextField: UITextField!
    var correctAnswer:String?
    var delegate:QuizViewController!
    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in subviews{
            if let contentView = subview as? UIView{
                contentView.frame = self.bounds
            }
        }
    }
    
        override func awakeFromNib() {
            super.awakeFromNib()
            textLabel.text=frontText
            
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.commonInit()
            
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.commonInit()
            
        }
     
        
        private func commonInit() {
            let bundle = Bundle.main
            if let viewToAdd = bundle.loadNibNamed("FlashCardView", owner: self, options: nil) {
                for view in viewToAdd {
                    if let contentView = view as? UIView {
                        
                        addSubview(contentView)
                        
                        
                        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        contentView.layer.cornerRadius = 25
                        contentView.layer.masksToBounds = true
                        flashCardLabel.layer.cornerRadius = 25
                        flashCardLabel.layer.masksToBounds = true

                        submitButton.addTarget(self, action: #selector(submitIsTapped), for: .touchUpInside)
                        
                        self.FlashCardTextField.delegate=self
                        return
                    }
                }
            }
        
        }

        @objc func submitIsTapped(_ sender:UIButton){
            guard let userAnswer = FlashCardTextField.text, let correctAnswer = correctAnswer else {return}
            if  userAnswer.lowercased() == correctAnswer.lowercased(){
                UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight){ self.flashCardLabel.backgroundColor = .green
                    self.textLabel.text="Well Done!!"
                    self.FlashCardTextField.isHidden=true
                    self.submitButton.isHidden=true
                    self.delegate.updateScore(by: 10)
                    
                }
            }else{
                UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight){
                    self.textLabel.text="Wrong!!"
                    self.flashCardLabel.backgroundColor = .red
                    self.FlashCardTextField.isHidden=true
                    self.submitButton.isHidden=true
                }
            }
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         submitIsTapped(submitButton) // Call submit when return is pressed
            FlashCardTextField.resignFirstResponder()
         return true
     }
    }
