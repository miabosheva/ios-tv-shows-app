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
    let imagePicker = UIImagePickerController()
    var authInfo: AuthInfo?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        backButton.tintColor = UIColor(named: "primary-color")
        self.navigationItem.leftBarButtonItem = backButton;
        fetchUserFromBackend()
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
}

private extension ProfileController {
 
    // MARK: - Helper Methods
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchUserFromBackend(){
        let keychain = Keychain(service: "com.infinum.tv-shows")
        guard let savedAuthInfo = try? keychain.getData("authInfo") else { return }
        let decoder = JSONDecoder()
        guard let authInfo = try? decoder.decode(AuthInfo.self, from: savedAuthInfo) else { return }
        
        self.authInfo = authInfo
        
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
                  setupUI()
              case .failure(let error):
                  print(error.localizedDescription)
              }
          }
    }
    
    func setupUI(){
        let url = self.user?.imageUrl ?? ""
        let imageUrl = URL(string: url)
        
        profileImage.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "ic-profile-placeholder"))
        profileImage.layer.cornerRadius = 50
        usernameLabel.text = self.user?.email ?? ""
    }
    
    func storeImage(_ image: UIImage) {
        guard
            let imageData = image.jpegData(compressionQuality: 0.9)
        else { return }

        let requestData = MultipartFormData()
        requestData.append(
            imageData,
            withName: "image",
            fileName: "image.jpg",
            mimeType: "image/jpg"
        )
        
        guard let authInfo else { return }

        AF
            .upload(
                multipartFormData: requestData,
                to: "https://tv-shows.infinum.academy/users",
                method: .put,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { dataResponse in
                print(dataResponse)
            }
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func changeProfilePhoto(_ sender: UIButton){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
                
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFill
            profileImage.image = pickedImage
            storeImage(pickedImage)
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
