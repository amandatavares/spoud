//
//  PersonalViewController.swift
//  THEAPP
//
//  Created by Ada 2018 on 11/06/18.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import Cloudinary

class PersonalViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var nomeTextfield: MyTextField!
    @IBOutlet weak var emailTextfield: MyTextField!
    @IBOutlet weak var senhaTextfield: MyTextField!
    @IBOutlet weak var phoneTextfield: MyTextField!
    
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var card: UIView!
    
    let imagePicker = UIImagePickerController()
    let config = CLDConfiguration(cloudName: "dny7llci8", apiKey: "434561441216885")
    var cloudinary: CLDCloudinary?
    
    var activeField: MyTextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        fotoPerfil.clipsToBounds = true
        
        cloudinary = CLDCloudinary(configuration: config)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        fotoPerfil.isUserInteractionEnabled = true
        fotoPerfil.addGestureRecognizer(tapGestureRecognizer)
        
        //Set textfields delegate
        nomeTextfield.delegate = self
        emailTextfield.delegate = self
        senhaTextfield.delegate = self
        phoneTextfield.delegate = self
        
        //keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //tapGesture
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        
        
        card.layer.masksToBounds = false
        card.clipsToBounds = false
        card.layer.cornerRadius = 5
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowRadius = 0.5;
        card.layer.shadowOpacity = 0.2;
    }
    
    @objc func returnTextView(gesture: UIGestureRecognizer) {
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    @IBAction func next(_ sender: Any) {
//        let pageViewController = self.parent as! PageViewController
//        pageViewController.nextPageWithIndex(index: 1)
        let pageViewController = self.parent as! PageViewController
        pageViewController.setViewControllers([pageViewController.orderedViewController[1]], direction: .forward, animated: true) { (_) in
            let parentViewController = pageViewController.parent as! SignUpViewController
            parentViewController.onboardingPageViewController(onboardingPageViewController: pageViewController, didUpdatePageIndex: 1)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        _ = tapGestureRecognizer.view as! UIImageView
        
        imagePicker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { (alert: UIAlertAction!) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction!) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (alert: UIAlertAction!) in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func nextButtonAction(_ sender: Any){
        let pageViewController = self.parent as! PageViewController
        pageViewController.nextPageWithIndex(index: 1)
        
        
    }

}

extension PersonalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagemEscolhida = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.fotoPerfil.contentMode = .scaleAspectFill
        self.fotoPerfil.image = imagemEscolhida
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }

}

//Spinner
extension PersonalViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension PersonalViewController: UITextFieldDelegate {
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

//Keyboard
extension PersonalViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if activeField == nil{
            return
        }
        
        print("Keyboard will show")
        
        if keyboardHeight != nil {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
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
                
                if self.activeField == self.senhaTextfield {
                    self.fotoPerfil.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
                
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
                
            }
        }
    }
    

    @objc func keyboardWillHide(notification: NSNotification) {
        
        if activeField == nil {
            return
        }
        
        self.parent?.navigationController?.navigationBar.isHidden = false

        
        UIView.animate(withDuration: 0.3) {
            
            if self.activeField == self.senhaTextfield {
                self.fotoPerfil.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
            self.constraintHeight.constant -= self.keyboardHeight
            
            self.scrollView.contentOffset = self.lastOffset
        }
        
        keyboardHeight = nil
    }
}
