//
//  studentLogInViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/14/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class studentLogInViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var studUsername: UITextField!
    @IBOutlet weak var studPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.studUsername.delegate = self
        self.studPassword.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func studLogInButton(_ sender: Any) {
        
        let studentUsernameText = studUsername.text;
        let studentPasswordText = studPassword.text;
        
        FIRAuth.auth()?.signIn(withEmail: studentUsernameText!, password: studentPasswordText!, completion: { (user, error) in
            if(error != nil){
                if(((error?.localizedDescription)! as String) == "There is no user record corresponding to this identifier. The user may have been deleted."){
                    self.myAlert(alertMessage: "Sorry, there are no accounts with that email")
                }else if(((error?.localizedDescription)! as String) == "The password is invalid or the user does not have a password."){
                    self.myAlert(alertMessage: "Sorry, the password you have entered is invalid.")
                }else{
                    print(error?.localizedDescription as Any)
                }
            }else{
                print("Student has logged in")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextController: studentHomeViewController = storyBoard.instantiateViewController(withIdentifier: "studentHome") as! studentHomeViewController
                self.present(nextController, animated:true, completion:nil)
            }
        })
        

    }
    
    //hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard with user hits "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        studUsername.resignFirstResponder()
        studPassword.resignFirstResponder()
        return(true)
    }
    
    func myAlert (alertMessage: String){
        
        let alert = UIAlertController(title: "Hi", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
