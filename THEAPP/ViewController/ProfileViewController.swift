//
//  ProfileViewController.swift
//  THEAPP
//
//  Created by Ada 2018 on 18/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit
import Cloudinary
import Alamofire

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    var imageViewProfile = ProfileImageView(image: UIImage(named: "semFoto-2"))
    
    let config = CLDConfiguration(cloudName: "dny7llci8", apiKey: "434561441216885")
    var cloudinary: CLDCloudinary?
    
    var universitario : Universitario?

    @IBOutlet weak var card: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudinary = CLDCloudinary(configuration: config)
        
        imageViewProfile.moveAndResizeImage(for: 60.0)
        imageViewProfile.setupUI(controller: self)
        
        if let savedUniversitario = UserDefaults.standard.object(forKey: "SavedUniversitario") as? Data {
            let decoder = JSONDecoder()
            if let loadedUniversitario = try? decoder.decode(Universitario.self, from: savedUniversitario) {
                self.universitario = loadedUniversitario
                nameLabel.text = loadedUniversitario.name
                universityLabel.text = loadedUniversitario.university
                majorLabel.text = loadedUniversitario.major
                yearLabel.text = loadedUniversitario.startDate
                fieldLabel.text = loadedUniversitario.area
                jobLabel.text = loadedUniversitario.job
                emailLabel.text = loadedUniversitario.email
                passwordLabel.text = loadedUniversitario.password
                imageViewProfile.cldSetImage(loadedUniversitario.imageUrl, cloudinary: cloudinary!)
                
            }
        }
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.007234328426, green: 0.5179384351, blue: 0.8449995518, alpha: 1)
        navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.007234328426, green: 0.5179384351, blue: 0.8449995518, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
        
        card.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        card.layer.masksToBounds = false
        card.clipsToBounds = false
        card.layer.cornerRadius = 5
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowRadius = 0.5;
        card.layer.shadowOpacity = 0.2;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageViewProfile.showImage(false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageViewProfile.isHidden = false
        imageViewProfile.showImage(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "SavedUniversitario")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Account", message: "Do you really want to delete your account?", preferredStyle: UIAlertControllerStyle.alert)
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
        }
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            let id = self.universitario?.id
            print(id)
            Alamofire.request("https://jamb-api.herokuapp.com/students/\(id!)", method: HTTPMethod.delete).responseJSON(completionHandler: { (json) in
                print(json)
                UserDefaults.standard.removeObject(forKey: "SavedUniversitario")
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            })
            
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

