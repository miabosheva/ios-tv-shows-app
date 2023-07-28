//
//  WriteReviewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 28.7.23.
//

import Foundation
import UIKit

final class WriteReviewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Write a Review"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = backButton;
        super.viewWillAppear(animated);
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
