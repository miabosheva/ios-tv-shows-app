//
//  ProfileController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 3.8.23.
//

import Foundation
import UIKit
import KeychainAccess
import Alamofire

final class ProfileController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    // MARK: - Properties
    
    var user: User?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        backButton.tintColor = UIColor(named: "primary-color")
        self.navigationItem.leftBarButtonItem = backButton;
        setupProfileImage()
        usernameLabel.text = self.user?.email ?? ""
    }
}

// MARK: - Actions

extension ProfileController {
    
    @IBAction func logoutButtonTap(){
        dismiss(animated: true, completion: {
            let keychain = Keychain(service: "com.infinum.tv-shows")
            keychain["authInfo"] = nil
            
            NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
            })
    }
    
    @IBAction func changeProfilePhoto(){
        
    }
}

private extension ProfileController {
 
    // MARK: - Helper Methods
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupProfileImage(){
        let keychain = Keychain(service: "com.infinum.tv-shows")
        guard let savedAuthInfo = try? keychain.getData("authInfo") else { return }
        let decoder = JSONDecoder()
        guard let authInfo = try? decoder.decode(AuthInfo.self, from: savedAuthInfo) else { return }
        
        AF
          .request(
              "https://tv-shows.infinum.academy/users/me",
              method: .get,
              headers: HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              switch dataResponse.result {
              case .success(let userResponse):
                  self.user = userResponse.user
              case .failure(let error):
                  print(error.localizedDescription)
              }
          }
        
        let url = self.user?.imageUrl ?? ""
        let imageUrl = URL(string: url)
        
        profileImage.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "ic-profile-placeholder"))
        profileImage.layer.cornerRadius = 50
    }
}
