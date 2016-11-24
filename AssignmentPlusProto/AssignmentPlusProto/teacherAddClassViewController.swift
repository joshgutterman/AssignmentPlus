//
//  teacherAddClassViewController.swift
//  AssignmentPlusProto
//
//  Created by Josh Gutterman on 11/21/16.
//  Copyright © 2016 CMPS 115. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class teacherAddClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {

    @IBOutlet weak var subjectPicker: UIPickerView!
    @IBOutlet weak var periodText: UITextField!
    @IBOutlet weak var classNameText: UITextField!
    @IBOutlet weak var termText: UITextField!
    
    @IBAction func addClassButton(_ sender: Any) {
        //INSER BUTTON STUFF HERE
    }

    //data for picker view
    var subjectArray = ["Science", "Math", "Literature", "History", "Art", "Government", "Language", "Music"];

    @IBAction func closeButton(_ sender: Any){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextController: teacherHomeViewController = storyBoard.instantiateViewController(withIdentifier: "teacherHome") as! teacherHomeViewController
        self.present(nextController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.periodText.delegate = self
        self.classNameText.delegate = self
        self.termText.delegate = self
        
        //numberpad for period tect field
        periodText.keyboardType = UIKeyboardType.numberPad

        // Input data into the picker view array
        subjectPicker.delegate = self
        subjectPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard with user hits "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        periodText.resignFirstResponder()
        classNameText.resignFirstResponder()
        termText.resignFirstResponder()
        return(true)
    }
    
    //insert subject data into each title of picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectArray[row]
    }
    
    //number of rows in subject picker based off of array components
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectArray.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //retreive data from subject picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedSubject = subjectArray[row]
    }

    
    
}
