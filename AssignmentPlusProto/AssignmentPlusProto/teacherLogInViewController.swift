//
//  teacherLogInViewController.swift
//  AssignmentPlusProto
//
//  Created by Kyle Fong on 11/17/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class teacherLogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var teacherLogInEmail: UITextField!
    @IBOutlet weak var teacherLogInPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.teacherLogInEmail.delegate = self
        self.teacherLogInPassword.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //This button instantiates signIn method and input check logic
    @IBAction func loginAction(_ sender: Any) {
        let teacherLogInEmailText = teacherLogInEmail.text;
        let teacherLogInPasswordText = teacherLogInPassword.text;
        
        //This function takes two arguments - teachersLogInEmailText and teachersLogInPasswordText as string values
        //If the teacher has entered an invalid email, the myAlert() function is called with parameters
        //If the teacher has entered an invalid password, the myAlert() function is called with parameters
        //the last 'else' statement confirms the teacher has logged in successfully and prints to the console
        FIRAuth.auth()?.signIn(withEmail: teacherLogInEmailText!, password: teacherLogInPasswordText!, completion: { (user, error) in
            if(error != nil){
                if(((error?.localizedDescription)! as String) == "There is no user record corresponding to this identifier. The user may have been deleted."){
                    self.myAlert(alertMessage: "Sorry, there are no accounts that exist with that email")
                }else if(((error?.localizedDescription)! as String) == "The password is invalid or the user does not have a password."){
                    self.myAlert(alertMessage: "Sorry, the password you have entered is invalid.")
                }else if(((error?.localizedDescription)! as String) == "The email address is badly formatted."){
                    self.myAlert(alertMessage: "The email address is badly formatted.")
                }else{
                    print(error?.localizedDescription as Any)
                }
            }else{
                //successful login, switch to teacher home view controller
                print("Teacher has logged in")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextController: teacherHomeViewController = storyBoard.instantiateViewController(withIdentifier: "teacherHome") as! teacherHomeViewController
                self.present(nextController, animated:true, completion:nil)
            }
        })
        
    }
    
    //Builds the user error message
    func myAlert(alertMessage: String){
        let alert = UIAlertController(title: "Hi", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated:true, completion:nil)
    }
    
    //hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard with user hits "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        teacherLogInEmail.resignFirstResponder()
        teacherLogInPassword.resignFirstResponder()
        return(true)
    }

    
   
}
