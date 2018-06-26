//
//  SignInViewController.swift
//  THEAPP
//
//  Created by Ada 2018 on 11/06/18.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: MyTextField!
    @IBOutlet weak var senhaTextfield: MyTextField!
    @IBOutlet weak var card: UIView!
    
    let URL_GET_DATA = "https://jamb-api.herokuapp.com/login"
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.backgroundColor = UIColor.clear
        //navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        emailTextfield.delegate = self
        senhaTextfield.delegate = self
        
        
        card.layer.masksToBounds = false
        card.clipsToBounds = false
        card.layer.cornerRadius = 5
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowRadius = 0.5;
        card.layer.shadowOpacity = 0.2;
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        let jsonObject: [String: Any]? = [
            "email": emailTextfield.text!,
            "password" : senhaTextfield.text!
        ]
        
        Alamofire.request("https://jamb-api.herokuapp.com/login", method: .post, parameters: jsonObject, encoding: JSONEncoding.default, headers: nil).responseJSON { json in
            
            print(json)
            
            guard let data = json.data else { return }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(LoginResponse.self, from: data)
                print(response)
                let universitario = response.student
                print(universitario)
                
                self.defaults.setValue(response.token, forKey: "Token")
                
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(universitario) {
                    let defaults = UserDefaults.standard
                    self.defaults.setValue(encoded, forKey: "SavedUniversitario")
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }catch {
                print("Wrong Password")
                let alert = UIAlertController(title: "Wrong Password", message: "Try again", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    @IBOutlet weak var entrar: UIButton!
    
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}


