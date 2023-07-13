//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 10.7.23.
//

import UIKit

final class LoginViewController : UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var numberOfTaps: Int = 0
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorOutlet.startAnimating()
        
        self.perform(#selector(LoginViewController.stopActivityIndicator), with: nil, afterDelay: 3.0)
        
    }
    
    // MARK: - Actions
    
    @IBAction func buttonAction() {
        numberOfTaps += 1
        labelOutlet.text = String(numberOfTaps)
        if activityIndicatorOutlet.isAnimating {
            activityIndicatorOutlet.stopAnimating()
        }
        else {
            activityIndicatorOutlet.startAnimating()
        }
    }
    
    // MARK: - Utility methods
    
    @objc private func stopActivityIndicator() {
        activityIndicatorOutlet.stopAnimating()
    }
}
