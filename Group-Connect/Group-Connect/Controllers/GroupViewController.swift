//
//  GroupViewController.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/11/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    @IBOutlet weak var hiUsernameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hiUsernameLabel.text = "Hi \(User.current.username)!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

