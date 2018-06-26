//
//  AcademicViewController.swift
//  THEAPP
//
//  Created by Ada 2018 on 19/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import Cloudinary
import Alamofire

class AcademicViewController: UIViewController {

    @IBOutlet weak var universityTextField: MyTextField!
    @IBOutlet weak var majorTextField: MyTextField!
    @IBOutlet weak var yearTextField: MyTextField!
    @IBOutlet weak var industryTextField: MyTextField!
    @IBOutlet weak var jobTextField: MyTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var card: UIView!
    
    let url = URL(string: "https://jamb-api.herokuapp.com/students/")
    
    let thePicker = UIPickerView()
    let myPickerDataUni = ["UFC", "IFCE", "Unifor", "UECE", "Uni7", "FIC"]
    let myPickerDataFields = ["Information Technology", "Natural, Physical Sciences", "Health", "Society and Culture", "Education"]
    
    let config = CLDConfiguration(cloudName: "dny7llci8", apiKey: "434561441216885")
    var cloudinary: CLDCloudinary?
    
    var activeField: MyTextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudinary = CLDCloudinary(configuration: config)
        
        //PICKER
        thePicker.delegate = self
        universityTextField.inputView = thePicker
        industryTextField.inputView = thePicker
        
        thePicker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .default
        toolBar.barTintColor = #colorLiteral(red: 0.337254902, green: 0.6352941176, blue: 0.8941176471, alpha: 1)
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = #colorLiteral(red: 0.337254902, green: 0.6352941176, blue: 0.8941176471, alpha: 1)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneBtnToolbar))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Choose one"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        universityTextField.inputAccessoryView = toolBar
        industryTextField.inputAccessoryView = toolBar

        //FINAL DO PICKER
        universityTextField.delegate = self
        majorTextField.delegate = self
        yearTextField.delegate = self
        industryTextField.delegate = self
        jobTextField.delegate = self
        
        //keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        card.layer.masksToBounds = false
        card.clipsToBounds = false
        card.layer.cornerRadius = 5
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowRadius = 0.5;
        card.layer.shadowOpacity = 0.2;
        
        
    }
    
    @objc func doneBtnToolbar() {
        if activeField == universityTextField{
            universityTextField.resignFirstResponder()
        } else if activeField == industryTextField {
            industryTextField.resignFirstResponder()
        }
    }
    
    func checkProfilePicture(image: UIImage) -> UIImage? {
        if image != #imageLiteral(resourceName: "profileimage") {
            return image
        } else {
            return nil
        }
    }

    @IBAction func save(_ sender: Any) {
        let parentview = self.parent as! PageViewController
        let personal = parentview.personalView!
        
        //ALERT
        guard let name = personal.nomeTextfield.text, !name.isEmpty,
            let phone = personal.phoneTextfield.text, !name.isEmpty,
            let email = personal.emailTextfield.text, !email.isEmpty,
            let password = personal.senhaTextfield.text, !password.isEmpty,
            let image = checkProfilePicture(image: personal.fotoPerfil.image!),
            let university = universityTextField.text, !university.isEmpty,
            let major = majorTextField.text, !major.isEmpty,
            let startDate = yearTextField.text, !startDate.isEmpty,
            let industry = industryTextField.text, !industry.isEmpty
            else{
                var stringArr = [String]()
                
                if (personal.nomeTextfield.text?.isEmpty)! {
                    stringArr.append("Name")
                }
                if (personal.phoneTextfield.text?.isEmpty)! {
                    stringArr.append("Phone")
                }
                if (personal.emailTextfield.text?.isEmpty)! {
                    stringArr.append("Email")
                }
                if (personal.senhaTextfield.text?.isEmpty)! {
                    stringArr.append("Password")
                }
                if (universityTextField.text?.isEmpty)! {
                    stringArr.append("University")
                }
                if (majorTextField.text?.isEmpty)! {
                    stringArr.append("Major")
                }
                if (yearTextField.text?.isEmpty)! {
                    stringArr.append("Year of Entry")
                }
                if (industryTextField.text?.isEmpty)! {
                    stringArr.append("Fields of Study")
                }
                if (personal.fotoPerfil.image == #imageLiteral(resourceName: "profileimage")) {
                    stringArr.append("Photo")
                }

        
                
                let reducedString = stringArr.reduce("") { (result, current) -> String in
                    return "\(result)\n \(current)"
                }
                
                let attributes = [NSAttributedStringKey.foregroundColor:UIColor.red]
                let attributedString = NSMutableAttributedString(string: reducedString, attributes: attributes)

                let messageString = NSMutableAttributedString(string: "Empty mandatory fields:", attributes: nil)
                messageString.append(attributedString)
                
                let alert = UIAlertController(title: "Invalid Registration", message: "Empty mandatory fields:", preferredStyle: UIAlertControllerStyle.alert)
                alert.setValue(messageString, forKey: "attributedMessage")
                let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
        
                return
        }
        
        
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        
        _ = PersonalViewController.displaySpinner(onView: self.view)
        
        let uploader = cloudinary?.createUploader()
        uploader?.upload(data: imageData!, uploadPreset: "mzqebrfj") { result, error in
            let imageUrl = result!.url!
            
            let jsonObject: [String: Any] = [
                "imageUrl": imageUrl,
                "name": name,
                "university" : university,
                "major" : major,
                "area" : industry,
                "startDate" : startDate,
                "job" : "None",
                "phone" : phone,
                "email": email,
                "password" : password
            ]
            
            
            Alamofire.request(self.url!, method: .post, parameters: jsonObject, encoding: JSONEncoding.default).responseJSON(completionHandler: { (json) in
                
                print(json)
                
                guard let data = json.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(PostResponse.self, from: data)
                    let universitario = response.data
                    print(universitario)
                    
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(universitario) {
                        let defaults = UserDefaults.standard
                        defaults.setValue(encoded, forKey: "SavedUniversitario")
                    }
                    
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    
                    
                } catch let err {
                    print("Err", err)
                }
                
            })
            
        }
    }
    
    @IBAction func previus(_ sender: Any) {
        let pageViewController = self.parent as! PageViewController
        pageViewController.setViewControllers([pageViewController.orderedViewController[0]], direction: .reverse, animated: true) { (_) in
            let parentViewController = pageViewController.parent as! SignUpViewController
            parentViewController.onboardingPageViewController(onboardingPageViewController: pageViewController, didUpdatePageIndex: 0)
        }
    }
    
}

extension AcademicViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField as! MyTextField
        lastOffset = self.scrollView.contentOffset
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        
        return true
    }
}

extension AcademicViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if activeField == nil{
            return
        }
        
        print("Academic Keyboard will show")
        
        if keyboardHeight != nil {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintHeight.constant += self.keyboardHeight
            })
            
            let scrollViewHeight = self.scrollView.frame.size.height
            let activeFieldOrigin = activeField?.superview?.convert((activeField?.frame.origin)!, to: self.view).y
            let activeFieldHeight = activeField?.frame.size.height
            
            let distanceToBottom = scrollViewHeight - (activeFieldOrigin! + activeFieldHeight!)
            
            let collapseSpace = keyboardHeight - distanceToBottom
            
            if collapseSpace < 0 {
                return
            }
            
            self.parent?.navigationController?.navigationBar.isHidden = true
            
            UIView.animate(withDuration: 0.3) {
                
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if activeField == nil{
            return
        }
        
        self.parent?.navigationController?.navigationBar.isHidden = false
        
        
        UIView.animate(withDuration: 0.3) {
            
            self.constraintHeight.constant -= self.keyboardHeight
            
            self.scrollView.contentOffset = self.lastOffset
        }
        
        keyboardHeight = nil
    }
}

extension AcademicViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeField == universityTextField{
            return myPickerDataUni.count
        } else if activeField == industryTextField {
            return myPickerDataFields.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeField == universityTextField{
            return myPickerDataUni[row]
        } else if activeField == industryTextField {
            return myPickerDataFields[row]
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeField == universityTextField{
            universityTextField.text = myPickerDataUni[row]
        } else if activeField == industryTextField {
            industryTextField.text = myPickerDataFields[row]
        }
    }
    
    
}
