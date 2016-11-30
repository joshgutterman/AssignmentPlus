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
    
    
    @IBOutlet weak var studentLogInEmail: UITextField!
    @IBOutlet weak var studentLogInPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.studentLogInEmail.delegate = self
        self.studentLogInPassword.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func studLogInButton(_ sender: Any) {
        let studentLogInEmailText = studentLogInEmail.text
        let studentLogInPasswordText = studentLogInPassword.text
        
        //This function takes two arguments - studentLogInEmailText and studentLogInPasswordText as string values
        //If the student has entered an invalid email, the myAlert() function is called with parameters
        //If the teacher has entered an invalid password, the myAlert() function is called with parameters
        //the last 'else' statement confirms the teacher has logged in successfully and prints to the console
        FIRAuth.auth()?.signIn(withEmail: studentLogInEmailText!, password: studentLogInPasswordText!, completion: { (user, error) in
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
        studentLogInEmail.resignFirstResponder()
        studentLogInPassword.resignFirstResponder()
        return(true)
    }
    
    func myAlert (alertMessage: String){
        let alert = UIAlertController(title: "Hi", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
