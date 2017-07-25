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
    
    var groupCode = ""

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
        
        
        
        //self.performSegue(withIdentifier: Constants.Segue.toMap, sender: nil)
    }

    @IBAction func createButtonTapped(_ sender: Any) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        GroupService.createGroup { (groupCode) in
            self.groupCode = groupCode
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { 
            self.performSegue(withIdentifier: Constants.Segue.toMap, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.toMap {
            let dest = segue.destination as! MapViewController
            dest.groupCode = self.groupCode
        }
    }
    
    @IBAction func unwindToGroupViewController(_ segue: UIStoryboardSegue) {
        
    }
    
    func dismissKeyboard() {
        groupCodeTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
}

