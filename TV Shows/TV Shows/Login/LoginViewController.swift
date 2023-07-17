//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 10.7.23.
//

import UIKit
import MBProgressHUD

final class LoginViewController : UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var rememberMeButton: UIButton!
    
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
        ]
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: placeholderAttributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttributes)
    }
    
    // MARK: - Actions
    @IBAction func rememberMeButtonTap() {
        
        rememberMeButton.tintColor = UIColor.white
        rememberMeButton.setImage(UIImage(systemName: "checkmark"), for: .selected)
        rememberMeButton.setImage(UIImage(), for: .normal)
        rememberMeButton.isSelected = !rememberMeButton.isSelected

    }
    
}
