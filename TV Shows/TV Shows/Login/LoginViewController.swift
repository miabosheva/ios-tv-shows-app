//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 10.7.23.
//

import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var labelOutlet: UILabel!
    var counter : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Test")
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        labelOutlet.text = String(counter)
        counter += 1
    }
    
}
