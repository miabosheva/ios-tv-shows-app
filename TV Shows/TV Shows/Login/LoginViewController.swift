//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 10.7.23.
//

import UIKit

final class LoginViewController : UIViewController {
    
    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    var counter : Int = 0
    
    @objc func stopActivityIndicator() {
        activityIndicatorOutlet.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorOutlet.startAnimating()
        
        self.perform(#selector(LoginViewController.stopActivityIndicator), with: nil, afterDelay: 3.0)
        
    }
    
    @IBAction func buttonAction() {
        counter += 1
        labelOutlet.text = String(counter)
        if(activityIndicatorOutlet.isAnimating){
            activityIndicatorOutlet.stopAnimating()
        }
        else{
            activityIndicatorOutlet.startAnimating()
        }
    }
    
}
