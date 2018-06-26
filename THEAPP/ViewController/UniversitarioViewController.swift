//
//  UniversitarioViewController.swift
//  THEAPP
//
//  Created by Ada 2018 on 15/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class UniversitarioViewController: UIViewController {

    var universitario : Universitario!
    
    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var universidadeLabel: UILabel!
    @IBOutlet weak var cursoLabel: UILabel!
    @IBOutlet weak var anoLabel: UILabel!
    @IBOutlet weak var trabalhoLabel: UILabel!
    @IBOutlet weak var card1: UIView!
    @IBOutlet weak var card2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        print(universitario)
        
        fotoImageView.af_setImage(withURL: URL(string: universitario.imageUrl)!)
        nomeLabel.text = universitario.name
        universidadeLabel.text = universitario.university
        cursoLabel.text = universitario.major
        
        card1.layer.masksToBounds = false
        card1.clipsToBounds = false
        card1.layer.cornerRadius = 5
        card1.layer.shadowOffset = CGSize(width: 0, height: 0)
        card1.layer.shadowRadius = 0.5;
        card1.layer.shadowOpacity = 0.2;
        
        card2.layer.masksToBounds = false
        card2.clipsToBounds = false
        card2.layer.cornerRadius = 5
        card2.layer.shadowOffset = CGSize(width: 0, height: 0)
        card2.layer.shadowRadius = 0.5;
        card2.layer.shadowOpacity = 0.2;
    }
    
    @IBAction func openMessage(_ sender: Any) {
        
        let sms: String = "sms:+5585998161640&body=Hello It`s me."
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
