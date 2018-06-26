//
//  EditProfileViewController.swift
//  THEAPP
//
//  Created by Ada 2018 on 18/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import Cloudinary

class EditProfileViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    
    let config = CLDConfiguration(cloudName: "dny7llci8", apiKey: "434561441216885")
    var cloudinary: CLDCloudinary?

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var universidadeTextfield: MyTextField!
    @IBOutlet weak var nomeTextfield: MyTextField!
    @IBOutlet weak var cursoTextfield: MyTextField!
    @IBOutlet weak var trabalhoTextfield: MyTextField!
    @IBOutlet weak var senhaTextfield: MyTextField!
    @IBOutlet weak var emailTextfield: MyTextField!
    @IBOutlet weak var anoIngressoTextfield: MyTextField!
    @IBOutlet weak var atuacaoTextfield: MyTextField!
    @IBOutlet weak var profileImage: ProfileImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
        
        card.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        card.layer.cornerRadius = 5
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowRadius = 0.5;
        card.layer.shadowOpacity = 0.2;
        
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        profileImage.gradientBorder()
        
        cloudinary = CLDCloudinary(configuration: config)
        
        if let savedPerson = UserDefaults.standard.object(forKey: "universitario") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(Universitario.self, from: savedPerson) {
                profileImage.cldSetImage(loadedPerson.imageUrl, cloudinary: cloudinary!)
            }
        }

    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        _ = tapGestureRecognizer.view as! UIImageView
        
        imagePicker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.title = "Change Photo"
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert: UIAlertAction!) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction!) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "There are unsaved informations", preferredStyle: UIAlertControllerStyle.alert)
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in }
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagemEscolhida = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.image = imagemEscolhida
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
}
