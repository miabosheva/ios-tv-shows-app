//
//  WriteReviewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 28.7.23.
//

import Foundation
import UIKit
import Alamofire

final class WriteReviewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    
    var authInfo: AuthInfo?
    var show: Show?

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Write a Review"
        textView.delegate = self
        textView.text = "Enter your comment here..."
        textView.textColor = UIColor.lightGray

        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = backButton;
        super.viewWillAppear(animated);
    }
    
    // MARK: - Actions
    
    @IBAction func submitButtonTap() {
        guard let show else { return }
        guard let authInfo else { return }
        
        let rating = ratingView.rating
        let comment = textView.text ?? ""
        let showid = show.id
        
        let parameters: [String : Any] = [
            "rating" : rating,
            "comment" : comment,
            "show_id" : showid
        ]
        
        AF
          .request(
            "https://tv-shows.infinum.academy/reviews",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers:
                HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: ReviewSubmitResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              switch dataResponse.result {
              case .success(_):
                  close()
              case .failure(let error):
                  print(error.localizedDescription)
              }
          }
    }
}

private extension WriteReviewController {
    
    // MARK: - Helper Methods
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension WriteReviewController: UITextViewDelegate {
    
    // MARK: - Placeholder function for textView
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {
            textView.text = "Enter your comment here..."
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            submitButton.isEnabled = false
        }
        
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
        
        if ratingView.rating > 0 && textView.textColor == .black && !textView.text.isEmpty {
            submitButton.isEnabled = true
        }
        else if ratingView.rating == 0 {
            submitButton.isEnabled = false
        }

        else {
            return true
        }
        return false
    }
}