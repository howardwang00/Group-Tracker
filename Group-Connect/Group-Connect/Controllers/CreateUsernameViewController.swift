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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
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
            
            print("Created new user: \(username)")
            
            User.setCurrent(User(uid: firebaseUser.uid, username: username), writeToUserDefaults: true)
            
            print("Segue: to Group Screen")
            self.performSegue(withIdentifier: Constants.Segue.toMain, sender: nil)
        }
    }
}

extension CreateUsernameViewController: UITextFieldDelegate {
    func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}

