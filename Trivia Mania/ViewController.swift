//
//  ViewController.swift
//  Trivia Mania
//
//  Created by Jesse Rosenthal on 6/25/25.
//

import UIKit

class ViewController: UIViewController {

    struct Question {
        let text: String
        let answers: [String]
        let correctAnswerIndex: Int
    }

    // MARK: - Main View Controller
    class QuizViewController: UIViewController {
        
        // MARK: - IBOutlets
        @IBOutlet weak var questionLabel: UILabel!
        @IBOutlet weak var progressLabel: UILabel!
        
        @IBOutlet weak var progressLabel: UILabel!
        @IBOutlet weak var progressView: UIProgressView!
        @IBOutlet weak var scoreLabel: UILabel!
        
        @IBOutlet weak var answerButton1: UIButton!
        @IBOutlet weak var answerButton2: UIButton!
        @IBOutlet weak var answerButton3: UIButton!
        @IBOutlet weak var answerButton4: UIButton!
        
        @IBOutlet weak var nextButton: UIButton!
        @IBOutlet weak var restartButton: UIButton!
        
        @IBOutlet weak var finalScoreView: UIView!
        @IBOutlet weak var finalScoreLabel: UILabel!
        @IBOutlet weak var finalPercentageLabel: UILabel!
        @IBOutlet weak var finalMessageLabel: UILabel!
        
        // MARK: - Properties
        private var questions: [Question] = [
            Question(text: "What is the capital of France?",
                    answers: ["London", "Berlin", "Paris", "Madrid"],
                    correctAnswerIndex: 2),
            
            Question(text: "Which planet is known as the Red Planet?",
                    answers: ["Venus", "Mars", "Jupiter", "Saturn"],
                    correctAnswerIndex: 1),
            
            Question(text: "What is the largest mammal in the world?",
                    answers: ["African Elephant", "Blue Whale", "Giraffe", "Polar Bear"],
                    correctAnswerIndex: 1),
            
            Question(text: "In which year did World War II end?",
                    answers: ["1944", "1945", "1946", "1947"],
                    correctAnswerIndex: 1),
            
            Question(text: "What is the chemical symbol for gold?",
                    answers: ["Go", "Gd", "Au", "Ag"],
                    correctAnswerIndex: 2),
            
            Question(text: "Which country is home to Machu Picchu?",
                    answers: ["Chile", "Peru", "Bolivia", "Ecuador"],
                    correctAnswerIndex: 1),
            
            Question(text: "What is the smallest prime number?",
                    answers: ["0", "1", "2", "3"],
                    correctAnswerIndex: 2),
            
            Question(text: "Who painted the Mona Lisa?",
                    answers: ["Vincent van Gogh", "Pablo Picasso", "Leonardo da Vinci", "Michelangelo"],
                    correctAnswerIndex: 2)
        ]
        
        private var currentQuestionIndex = 0
        private var score = 0
        private var selectedAnswerIndex: Int?
        private var answerButtons: [UIButton] = []
        
        // MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupAnswerButtons()
            displayCurrentQuestion()
        }
        
        // MARK: - Setup Methods
        private func setupUI() {
            title = "Quiz Challenge"
            
            // Configure answer buttons
            answerButtons = [answerButton1, answerButton2, answerButton3, answerButton4]
            
            for (index, button) in answerButtons.enumerated() {
                button.tag = index
                
                // Use modern UIButton.Configuration for iOS 15+
                if #available(iOS 15.0, *) {
                    var config = UIButton.Configuration.plain()
                    config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                    config.titleAlignment = .leading
                    config.background.cornerRadius = 12
                    config.background.strokeWidth = 2
                    config.background.strokeColor = UIColor.systemGray4
                    button.configuration = config
                } else {
                    // Fallback for iOS 14 and earlier
                    button.layer.cornerRadius = 12
                    button.layer.borderWidth = 2
                    button.titleLabel?.numberOfLines = 0
                    button.titleLabel?.textAlignment = .left
                    button.contentHorizontalAlignment = .left
                    button.titleEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
                }
            }
            
            // Configure other UI elements
            questionLabel.numberOfLines = 0
            questionLabel.textAlignment = .center
            
            nextButton.layer.cornerRadius = 12
            nextButton.isHidden = true
            
            restartButton.layer.cornerRadius = 12
            
            finalScoreView.layer.cornerRadius = 16
            finalScoreView.isHidden = true
            
            progressView.layer.cornerRadius = 4
            progressView.clipsToBounds = true
            
            // Set initial colors
            resetButtonColors()
        }
        
        private func setupAnswerButtons() {
            for button in answerButtons {
                button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
            }
        }
        
        // MARK: - Display Methods
        private func displayCurrentQuestion() {
            guard currentQuestionIndex < questions.count else {
                showFinalScore()
                return
            }
            
            let question = questions[currentQuestionIndex]
            
            // Update question text
            questionLabel.text = question.text
            
            // Update progress
            progressLabel.text = "Question \(currentQuestionIndex + 1) of \(questions.count)"
            progressView.progress = Float(currentQuestionIndex + 1) / Float(questions.count)
            
            // Update score
            scoreLabel.text = "Score: \(score)/\(currentQuestionIndex)"
            
            // Update answer buttons
            for (index, button) in answerButtons.enumerated() {
                button.setTitle(question.answers[index], for: .normal)
                button.isEnabled = true
            }
            
            // Reset UI state
            resetButtonColors()
            nextButton.isHidden = true
            selectedAnswerIndex = nil
        }
        
        private func resetButtonColors() {
            for button in answerButtons {
                if #available(iOS 15.0, *) {
                    var config = button.configuration ?? UIButton.Configuration.plain()
                    config.background.backgroundColor = UIColor.systemBackground
                    config.baseForegroundColor = UIColor.label
                    config.background.strokeColor = UIColor.systemGray4
                    button.configuration = config
                } else {
                    button.backgroundColor = UIColor.systemBackground
                    button.setTitleColor(UIColor.label, for: .normal)
                    button.layer.borderColor = UIColor.systemGray4.cgColor
                }
            }
        }
        
        private func showFinalScore() {
            finalScoreView.isHidden = false
            
            let percentage = Int(round(Double(score) / Double(questions.count) * 100))
            
            finalScoreLabel.text = "\(score)/\(questions.count)"
            finalPercentageLabel.text = "\(percentage)%"
            
            if percentage >= 80 {
                finalMessageLabel.text = "Excellent work! 🎉"
                finalMessageLabel.textColor = UIColor.systemGreen
            } else if percentage >= 60 {
                finalMessageLabel.text = "Good job! 👍"
                finalMessageLabel.textColor = UIColor.systemBlue
            } else {
                finalMessageLabel.text = "Keep practicing! 💪"
                finalMessageLabel.textColor = UIColor.systemOrange
            }
            
            // Hide quiz elements
            questionLabel.isHidden = true
            for button in answerButtons {
                button.isHidden = true
            }
            nextButton.isHidden = true
            progressLabel.isHidden = true
            progressView.isHidden = true
            scoreLabel.isHidden = true
        }
        
        // MARK: - Action Methods
        @objc private func answerButtonTapped(_ sender: UIButton) {
            guard selectedAnswerIndex == nil else { return }
            
            selectedAnswerIndex = sender.tag
            let correctAnswerIndex = questions[currentQuestionIndex].correctAnswerIndex
            
            // Disable all buttons
            for button in answerButtons {
                button.isEnabled = false
            }
            
            // Color the buttons based on correctness
            for (index, button) in answerButtons.enumerated() {
                if #available(iOS 15.0, *) {
                    var config = button.configuration ?? UIButton.Configuration.plain()
                    
                    if index == correctAnswerIndex {
                        // Correct answer - green
                        config.background.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
                        config.baseForegroundColor = UIColor.systemGreen
                        config.background.strokeColor = UIColor.systemGreen
                    } else if index == selectedAnswerIndex {
                        // Selected wrong answer - red
                        config.background.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
                        config.baseForegroundColor = UIColor.systemRed
                        config.background.strokeColor = UIColor.systemRed
                    } else {
                        // Other answers - gray
                        config.background.backgroundColor = UIColor.systemGray5
                        config.baseForegroundColor = UIColor.systemGray
                        config.background.strokeColor = UIColor.systemGray4
                    }
                    
                    button.configuration = config
                } else {
                    // Fallback for iOS 14 and earlier
                    if index == correctAnswerIndex {
                        button.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
                        button.setTitleColor(UIColor.systemGreen, for: .normal)
                        button.layer.borderColor = UIColor.systemGreen.cgColor
                    } else if index == selectedAnswerIndex {
                        button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
                        button.setTitleColor(UIColor.systemRed, for: .normal)
                        button.layer.borderColor = UIColor.systemRed.cgColor
                    } else {
                        button.backgroundColor = UIColor.systemGray5
                        button.setTitleColor(UIColor.systemGray, for: .normal)
                        button.layer.borderColor = UIColor.systemGray4.cgColor
                    }
                }
            }
            
            // Update score if correct
            if selectedAnswerIndex == correctAnswerIndex {
                score += 1
            }
            
            // Show next button or auto-advance
            if currentQuestionIndex < questions.count - 1 {
                nextButton.isHidden = false
                // Auto-advance after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if !self.nextButton.isHidden {
                        self.nextButtonTapped(self.nextButton)
                    }
                }
            } else {
                // Last question - show final score after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.showFinalScore()
                }
            }
        }
        
        @IBAction func nextButtonTapped(_ sender: UIButton) {
            currentQuestionIndex += 1
            displayCurrentQuestion()
        }
        
        @IBAction func restartButtonTapped(_ sender: UIButton) {
            // Reset all properties
            currentQuestionIndex = 0
            score = 0
            selectedAnswerIndex = nil
            
            // Show quiz elements
            questionLabel.isHidden = false
            for button in answerButtons {
                button.isHidden = false
            }
            progressLabel.isHidden = false
            progressView.isHidden = false
            scoreLabel.isHidden = false
            
            // Hide final score
            finalScoreView.isHidden = true
            
            // Display first question
            displayCurrentQuestion()
        }
    }
}
