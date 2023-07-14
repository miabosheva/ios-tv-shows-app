//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 10.7.23.
//

import UIKit
import MBProgressHUD
import Alamofire

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
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
        ]
        
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
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
    
    @IBAction func loginButtonPressed() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        loginUserWith(email: email, password: password)
    }
    @IBAction func registerButtonPressed() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        registerUserWith(email: email, password: password)
    }
    
}

// MARK: - Navigate to Home Controller

private extension LoginViewController {
    
    private func navigateToHomeController() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
            
        let homeController = storyboard.instantiateViewController(withIdentifier: "homeController")
            
        navigationController?.pushViewController(homeController, animated: true)
    }
}

// MARK: - Register + automatic JSON parsing

private extension LoginViewController {

    func registerUserWith(email: String, password: String) {
        MBProgressHUD.showAdded(to: view, animated: true)

        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]

        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let user):
                    print("Success: \(user)")
                    navigateToHomeController()
                case .failure(let error):
                    print("API/Serialization failure: \(error)")
                }
            }
    }

}

// MARK: - Login + automatic JSON parsing

private extension LoginViewController {

    func loginUserWith(email: String, password: String) {
        MBProgressHUD.showAdded(to: view, animated: true)

        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        AF
            .request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let userResponse):
                    let headers = dataResponse.response?.headers.dictionary ?? [:]
                    self.handleSuccesfulLogin(for: userResponse.user, headers: headers)
                    print("Successful login.")
                    navigateToHomeController()
                case .failure(let error):
                    //print("API/Serialization failure: \(error)")
                    print("Login failure error: \(error.localizedDescription).")
                }
            }
    }

    // Headers will be used for subsequent authorization on next requests
    func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            print("Missing headers")
            return
        }
        print("\(user)\n")
    }
}

