//
//  HomeViewController.swift
//  CKUsers
//
//  Created by Cameron Ingham on 8/8/18.
//  Copyright © 2018 Cameron Ingham. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var welcomeLabel: UILabel!
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = UserController.shared.user else {return}
        welcomeLabel.text = "Welcome \(user.username)!"
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

}
