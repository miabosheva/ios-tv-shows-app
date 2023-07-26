//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 14.7.23.
//

import Foundation
import UIKit
import Alamofire
import MBProgressHUD

final class HomeViewController : UIViewController {
    
    // MARK: - Properties
    
    public var authInfo: AuthInfo!
    public var userResponse: UserResponse!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension HomeViewController {
    
    func listShows(){
        
        
        AF
          .request(
              "https://tv-shows.infinum.academy/shows",
              method: .get,
              parameters: ["page": "1", "items": "100"], // pagination arguments
              headers: HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: ShowsResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              MBProgressHUD.hide(for: self.view, animated: true)
              switch dataResponse.result {
              case .success(let shows):
                  print (shows)
              case .failure(let error):
                  print(error)
              }
          }
    }
}
