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
    
    @IBOutlet weak var visibilityButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAtttributedPlacehordersEmailAndPassword()
        setTitleColorLoginAndRegisterBtn()
        setButtonsAsDisabled()
    }
    
    // MARK: - Actions
    
    @IBAction func rememberMeButtonTap() {
        rememberMeButton.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        rememberMeButton.setImage(UIImage(systemName: "square"), for: .normal)
        rememberMeButton.isSelected = !rememberMeButton.isSelected
    }
    
    @IBAction func visibilityButtonTap() {
        visibilityButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        visibilityButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        
        visibilityButton.isSelected = !visibilityButton.isSelected
        
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func editingChangedInPasswordField() {
        checkIfTextFieldsAreEmpty()
    }
    
    @IBAction func editingChangedInEmailField() {
        checkIfTextFieldsAreEmpty()
    }
    
    // MARK: - Helper Methods
    
    private func checkIfTextFieldsAreEmpty(){
        if emailTextField.text == "" || passwordTextField.text == ""{
            setButtonsAsDisabled()
        } else {
            setButtonsAsEnabled()
        }
    }
    
    private func setButtonsAsDisabled(){
        loginButton.alpha = 0.5
        loginButton.isEnabled = false
        registerButton.isEnabled = false
    }
    
    private func setButtonsAsEnabled(){
        loginButton.alpha = 1.0
        loginButton.isEnabled = true
        registerButton.isEnabled = true
    }
    
    private func setAtttributedPlacehordersEmailAndPassword(){
        
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
        ]
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: placeholderAttributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttributes)
    }
    
    private func setTitleColorLoginAndRegisterBtn(){
        loginButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .disabled)
        registerButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .disabled)
    }
}
