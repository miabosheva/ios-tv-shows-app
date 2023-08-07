//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 10.7.23.
//

import UIKit
import MBProgressHUD
import Alamofire
import KeychainAccess

final class LoginViewController : UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var visibilityButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Properties
    
    private var userResponse: UserResponse!
    private var authInfo: AuthInfo!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAtttributedPlacehordersEmailAndPassword()
        setTitleColorLoginAndRegisterBtn()
        setButtonsAsDisabled()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    // MARK: - Actions
    
    @IBAction func loginButtonPressed() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        loginUserWith(email: email, password: password)
    }
    
    @IBAction func registerButtonPressed() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        registerUserWith(email: email, password: password)
    }
}

// MARK: - Navigate to Home Controller

private extension LoginViewController {
    
    func navigateToHomeController() {
        let tabBarController = UITabBarController()
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        let homeControllerShows = storyboard.instantiateViewController(withIdentifier: "homeController") as! HomeViewController
        setupHomeControllerShows(showsVC: homeControllerShows)
        
        let homeControllerTopRated = storyboard.instantiateViewController(withIdentifier: "homeController") as! HomeViewController
        setupHomeControllerTopRated(topRatedVC: homeControllerTopRated)
        
        let controllers = [homeControllerShows, homeControllerTopRated]
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        tabBarController.tabBar.tintColor = UIColor(named: "primary-color")
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    func setupHomeControllerShows(showsVC: HomeViewController) {
        showsVC.authInfo = authInfo
        showsVC.userResponse = self.userResponse
        showsVC.requestURL = "https://tv-shows.infinum.academy/shows"
        showsVC.tabBarItem.tag = 1
        showsVC.tabBarItem.image = UIImage(named: "ic-show-selected")
        showsVC.title = "Shows"
    }
    
    func setupHomeControllerTopRated(topRatedVC: HomeViewController){
        topRatedVC.authInfo = authInfo
        topRatedVC.userResponse = self.userResponse
        topRatedVC.requestURL = "https://tv-shows.infinum.academy/shows/top_rated"
        topRatedVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        topRatedVC.title = "Top Rated"
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
                    let headers = dataResponse.response?.headers.dictionary ?? [:]
                    self.handleSuccesfulLogin(for: user.user, headers: headers)
                    userResponse = user
                    navigateToHomeController()
                case .failure(let error):
                    print("API/Serialization failure: \(error)")
                    loginButton.shake()
                    showAlert()
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
                    self.userResponse = userResponse
                    navigateToHomeController()
                case .failure(let error):
                    print("Login failure error: \(error.localizedDescription).")
                    loginButton.shake()
                    showAlert()
                }
            }
    }
    
    func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            print("Missing headers")
            return
        }
        print("\(user)\n")
        if rememberMeButton.isSelected {
            // Store headers in user defaults
            saveState(authInfo: authInfo)
        }
        self.authInfo = authInfo
    }
}

// MARK: - Storing in User Defaults

private extension LoginViewController {
    
    func saveState(authInfo: AuthInfo) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(authInfo) {
            let keychain = Keychain(service: "com.infinum.tv-shows")
            keychain[data: "authInfo"] = encoded
        }
    }
}

// MARK: - Helper Methods

private extension LoginViewController {
    
    func checkIfTextFieldsAreEmpty() {
        if emailTextField.text == "" || passwordTextField.text == "" {
            setButtonsAsDisabled()
        } else {
            setButtonsAsEnabled()
        }
    }
    
    func setButtonsAsDisabled() {
        loginButton.alpha = 0.5
        loginButton.isEnabled = false
        registerButton.isEnabled = false
    }
    
    func setButtonsAsEnabled() {
        loginButton.alpha = 1.0
        loginButton.isEnabled = true
        registerButton.isEnabled = true
    }
    
    func setAtttributedPlacehordersEmailAndPassword() {
        
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
        ]
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: placeholderAttributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttributes)
    }
    
    func setTitleColorLoginAndRegisterBtn() {
        loginButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .disabled)
        registerButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .disabled)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Login failed", message: "Credentials are not valid.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
    }
}
