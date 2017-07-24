//
//  GroupViewController.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/11/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var hiUsernameLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var groupCodeTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hiUsernameLabel.text = "Hi \(User.current.username)!"
        joinButton.layer.cornerRadius = 5
        createButton.layer.cornerRadius = 5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func joinButtonTapped(_ sender: Any) {
        guard let code = groupCodeTextField.text else { return }
        print(code)
        
        //check if group code is valid
        
        //self.performSegue(withIdentifier: Constants.Segue.toMap, sender: nil)
    }

    @IBAction func createButtonTapped(_ sender: Any) {
        
        //create group in firebase
        
        GroupService.createGroup { (groupCode) in
            guard let groupCode = groupCode else { return }
            print("New Group: \(groupCode)")
            
            User.setGroup(groupCode)
        }
        
        self.performSegue(withIdentifier: Constants.Segue.toMap, sender: nil)
    }
    
    func dismissKeyboard() {
        groupCodeTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
}

