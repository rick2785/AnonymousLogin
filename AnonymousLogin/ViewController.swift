//
//  ViewController.swift
//  AnonymousLogin
//
//  Created by Rickey Hrabowskie on 10/11/16.
//  Copyright © 2016 Rickey Hrabowskie. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var firebase: FIRDatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firebase = FIRDatabase.database().reference()
        
        if let user = FIRAuth.auth()?.currentUser {
            
            self.firebase!.child("users/\(user.uid)/userID").setValue(user.uid) // Updates userID value with the unique identifier
            
        } else {
            
            FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
                
                if error != nil {
                    
                    let alert = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    self.firebase!.child("users").child(user!.uid).setValue(["userID" : user!.uid]) // Rewrites the entire object or creates it
                    
                }
            })
            
        }
    }

    @IBAction func createAction(_ sender: Any) {
        
        guard let email = self.emailField.text else { return }
        guard let password = self.passwordField.text else { return }
        
        if email != "" && password != "" {
            
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
            
            FIRAuth.auth()?.currentUser?.link(with: credential, completion: { (user, error) in
                
                if error != nil {
                    
                    let alert = UIAlertController(title: "Oops2!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    self.firebase?.child("users/\(user!.uid)/email").setValue(user!.email!)
                    
                }
                
            })
            
        } else {
            
            let alert = UIAlertController(title: "Oops!", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
            
        }
    }


}

