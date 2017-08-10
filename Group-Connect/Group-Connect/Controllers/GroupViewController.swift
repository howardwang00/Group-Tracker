//
//  GroupViewController.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/11/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var editUsername: UIBarButtonItem!
    
    var groupCode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let groupCode = User.current.groupCode {
            //print("User already in group")
            self.groupCode = groupCode
            self.performSegue(withIdentifier: Constants.Segue.toMap, sender: nil)
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(color: .blue)]
        //navigationController?.navigationBar.tintColor = UIColor(color: .blueGreen)
        self.title = "Hi \(User.current.username)!"
        self.joinButton.layer.cornerRadius = 5
        self.createButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func joinButtonTapped(_ sender: Any) {
        presentGroupCodeAlert()
    }
    @IBAction func editUsernameTapped(_ sender: Any) {
        let editUsernameAlertController = UIAlertController(title: "Change Name", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            guard let changeNameTextField = editUsernameAlertController.textFields?[0],
                let username = changeNameTextField.text else { return }
            User.setUsername(username) //Later need to set usernames in Firebase for multiple groups
            self.title = "Hi \(User.current.username)!"
        }
        confirmAction.isEnabled = false
        
        editUsernameAlertController.addTextField { (changeNameTextField) in
            changeNameTextField.placeholder = "New Name"
            NotificationCenter.default.addObserver(forName: nil, object: changeNameTextField, queue: nil, using: { (notification) in
                confirmAction.isEnabled = changeNameTextField.text != ""
            })
        }
        
        editUsernameAlertController.addAction(confirmAction)
        editUsernameAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editUsernameAlertController, animated: true, completion: nil)
    }

    @IBAction func createButtonTapped(_ sender: Any) {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loadingView.center = self.view.center
        loadingView.hidesWhenStopped = true
        loadingView.startAnimating()
        self.view.addSubview(loadingView)
        
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        GroupService.createGroup { (groupCode) in
            self.groupCode = groupCode
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            loadingView.stopAnimating()
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
        self.view.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    private func presentGroupCodeAlert() {
        let groupCodeAlertController = UIAlertController(title: "Group Code", message: "Enter a Group Code to Join an Existing Group!", preferredStyle: .alert)
        
        let joinAction = UIAlertAction(title: "Join", style: .default, handler: { (action) in
            guard let groupCodeTextField = groupCodeAlertController.textFields?[0],
                let groupCode = groupCodeTextField.text else { return }
            
            let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            loadingView.center = self.view.center
            loadingView.hidesWhenStopped = true
            loadingView.startAnimating()
            self.view.addSubview(loadingView)
            
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            self.view.isUserInteractionEnabled = false
            
            self.checkGroupCode(groupCode: groupCode, loadingView: loadingView)
        })
        joinAction.isEnabled = false
        
        groupCodeAlertController.addTextField { (groupCodeTextField) in
            groupCodeTextField.placeholder = "Group Code"
            groupCodeTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
            NotificationCenter.default.addObserver(forName: nil, object: groupCodeTextField, queue: nil, using: { notification in
                joinAction.isEnabled = groupCodeTextField.text?.characters.count == 4
            })
            
        }
        groupCodeAlertController.addAction(joinAction)
        groupCodeAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(groupCodeAlertController, animated: true, completion: nil)
    }
    
    private func checkGroupCode(groupCode: String?, loadingView: UIActivityIndicatorView) {
        guard let groupCode = groupCode else {
            return
        }
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        GroupService.joinGroup(groupCode: groupCode) { (groupExists) in
            loadingView.stopAnimating()
            
            if groupExists {
                self.groupCode = groupCode
            } else {
                let alertController = UIAlertController(title: "Group Code Invalid", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
                    self.presentGroupCodeAlert()
                }))
                
                self.present(alertController, animated: true, completion: nil)
                
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
                self.view.isUserInteractionEnabled = true
                
                return    //dispatchGroup does not leave and does not segue to Map
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            self.performSegue(withIdentifier: Constants.Segue.toMap, sender: nil)
        }
    }
    
}

