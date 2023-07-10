//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 10.7.23.
//

import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var ActivityIndicatorOutlet: UIActivityIndicatorView!
    var counter : Int = 0
    
    @objc func stopActivityIndicator()
    {
        ActivityIndicatorOutlet.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicatorOutlet.startAnimating()
        
        self.perform(#selector(LoginViewController.stopActivityIndicator), with: nil, afterDelay: 3.0)
        
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        counter += 1
        labelOutlet.text = String(counter)
        if(ActivityIndicatorOutlet.isAnimating){
            ActivityIndicatorOutlet.stopAnimating()
        }
        else{
            ActivityIndicatorOutlet.startAnimating()
        }
    }
    
}
