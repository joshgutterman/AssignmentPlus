//
//  studentSubjectViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/29/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase

class studentSubjectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var transitionFlag = false
    var selectedSubject:String = ""
    @IBOutlet weak var subjectPicker: UIPickerView!

    //Button action to transition back to the studentHomeViewController
    @IBAction func backButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: studentHomeViewController = storyBoard.instantiateViewController(withIdentifier: "studentHome") as! studentHomeViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    //This button action instantiates a checkError method
    //If input is okay, a flag is set to true and returned, then
    //the studentClassViewController and View is instantiated
    @IBAction func nextButton(_ sender: Any) {
        checkForTextFieldErrors()
        if(transitionFlag == true){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextController: studentClassViewController = storyBoard.instantiateViewController(withIdentifier: "studentClass") as! studentClassViewController
            nextController.subjectValue = selectedSubject
            self.present(nextController, animated:true, completion:nil)
        }
    }
    
    //Checks user input for errors
    func checkForTextFieldErrors(){
        if(selectedSubject == ""){
          myAlert(alertMessage: "Please select a subject")
        }else{
            transitionFlag = true
        }
    }
    
    //data for picker view
    var subjectArray = ["Science", "Math", "Literature", "History", "Art", "Government", "Language", "Music"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Input data into the picker view array
        subjectPicker.delegate = self
        subjectPicker.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //insert subject data into each title of picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectArray[row]
    }
    
    //number of rows in subject picker based off of array components
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectArray.count
    }
    
    //This function declares the number of pickerViews in our subjectPickerView
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //retreive data from subject picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedSubjectInitializer = subjectArray[row]
        selectedSubject = selectedSubjectInitializer
    }
    
    //Builds the user error message
    func myAlert(alertMessage: String){
        let alert = UIAlertController(title: "Hi", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated:true, completion:nil)
    }
}
