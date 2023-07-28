//
//  WriteReviewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 28.7.23.
//

import Foundation
import UIKit

final class WriteReviewController: UIViewController {
    
    // MARK: - Properties
    
    var authInfo: AuthInfo?
    var show: Show?

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Write a Review"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = backButton;
        super.viewWillAppear(animated);
    }
    
}

private extension WriteReviewController {
    
    // MARK: - Helper Methods
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
