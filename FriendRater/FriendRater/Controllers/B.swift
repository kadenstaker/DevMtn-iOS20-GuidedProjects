//
//  FriendDetailViewController.swift
//  FriendRater
//
//  Created by Cameron Ingham on 7/7/18.
//  Copyright © 2018 Cameron Ingham. All rights reserved.
//

import UIKit

class FriendDetailViewController: UIViewController, UITextFieldDelegate {
    
    var friend: Friend = Friend(name: "", rating: 0)
    var segueIdentifier = ""

    @IBOutlet weak var friendTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTextField.delegate = self
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.shouldPop))
        friendTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        if(segueIdentifier == "ToFriendDetail"){
            title = friend.name
        }
        else{
            title = "Add Friend"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(segueIdentifier == "ToFriendDetail"){
            self.friendTextField.text = friend.name
            self.ratingLabel.text = "Rating: \(friend.rating)"
            self.ratingSlider.value = Float(friend.rating)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let friendName = textField.text, !friendName.trimmingCharacters(in: .whitespaces).isEmpty else{
            self.title = "Add Friend"
            return
        }
        self.title = friendName
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func shouldPop(){
        guard let friendName = friendTextField.text, !friendName.isEmpty else{
            return
        }
        let updatedFriend = Friend(name: friendName.trimmingCharacters(in: .whitespaces), rating: Int(self.ratingSlider.value))
        guard let friendIndex = FriendController.shared.friends.index(of: friend) else{
            return
        }
        
        if(FriendController.shared.friends[friendIndex] != updatedFriend){
            let alert = UIAlertController(title: "Cancel Changes?", message: "Are you sure you want to cancel the changes you made?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (alert: UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
            }
            let NoAction = UIAlertAction(title: "No", style: .default)
            
            alert.addAction(yesAction)
            alert.addAction(NoAction)
            
            present(alert, animated: true, completion:nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    
    @IBAction func sliderDidChange(_ sender: UISlider) {
        ratingLabel.text = "Rating: \(Int(sender.value))"
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let friendName = friendTextField.text, !friendName.isEmpty else{
            return
        }
        if(segueIdentifier == "ToAddFriend"){
            FriendController.shared.createFriend(name: friendName.trimmingCharacters(in: .whitespaces), rating: Int(ratingSlider.value))
            self.navigationController?.popViewController(animated: true)
        }
        else if(segueIdentifier == "ToFriendDetail"){
            let updatedFriend = Friend(name: friendName.trimmingCharacters(in: .whitespaces), rating: Int(self.ratingSlider.value))
            guard let friendIndex = FriendController.shared.friends.index(of: friend) else{
                return
            }
            FriendController.shared.friends[friendIndex] = updatedFriend
            FriendController.shared.saveFriends()
            self.navigationController?.popViewController(animated: true)
        }
    }

}
