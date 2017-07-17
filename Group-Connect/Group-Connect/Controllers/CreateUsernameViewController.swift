//
//  CreateUsernameViewController.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/12/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateUsernameViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        Auth.auth().signInAnonymously { (FIRuser, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            guard let firebaseUser = FIRuser else {
                fatalError("Unable to create new user")
            }
            
            print("Signed in successfully to Firebase")
            
            UserService.createUser(firebaseUser, username: username) { (user) in
                guard let user = user else { return }
                print("Created new user: \(user.username)")
                
                User.setCurrent(user, writeToUserDefaults: true)
                
                print("Segue - ing")
//                let initialViewController = UIStoryboard.initialViewController(for: .main)
//                self.view.window?.rootViewController = initialViewController
//                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}

