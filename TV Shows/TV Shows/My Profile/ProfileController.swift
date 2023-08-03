//
//  ProfileController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 3.8.23.
//

import Foundation
import UIKit

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
        let url = self.user?.imageUrl ?? ""
        let imageUrl = URL(string: url)
        
        profileImage.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "ic-profile-placeholder"))
        profileImage.layer.cornerRadius = 50
    }
}
