//
//  MeetupViewController.swift
//  Group-Connect
//
//  Created by Howard Wang on 8/4/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import UIKit

class MeetupViewController: UIViewController {
    @IBOutlet weak var display: UIView!
    @IBOutlet weak var titleTextField: UITextField!

    override func viewDidLoad() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //view.isOpaque = true
        display.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MeetupViewController: UITextFieldDelegate {
    func dismissKeyboard() {
        titleTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
