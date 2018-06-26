//
//  FilterViewController.swift
//  THEAPP
//
//  Created by Ada 2018 on 11/06/18.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit



class FilterViewController: UIViewController {

    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet var fields: [TagButton]!
    
    @IBOutlet var universities: [TagButton]!

    var delegate: FilterDelegate?
    
    var fieldsArray : [String] = []
    var universitiesArray : [String] = []
    
    var fieldsIndex : [Int] = []
    var universitiesIndex : [Int] = []
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if let fields = defaults.value(forKey: "fields") {
            fieldsIndex = fields as! [Int]
            for index in fieldsIndex {
                print("index \(index)")
                self.fields[index].isChecked = true
            }
        }
        
        if let universities = defaults.value(forKey: "universities") {
            universitiesIndex = universities as! [Int]
            for index in universitiesIndex {
                self.universities[index].isChecked = true
            }
        }

        
        filterView.layer.masksToBounds = false
        filterView.clipsToBounds = false
        filterView.layer.cornerRadius = 5
        filterView.layer.shadowOffset = CGSize(width: 0, height: 0)
        filterView.layer.shadowRadius = 0.5;
        filterView.layer.shadowOpacity = 0.2;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func apply(_ sender: Any) {
        
        fieldsArray = []
        fieldsIndex = []
        universitiesArray = []
        universitiesIndex = []
        
        for (i, field) in fields.enumerated() {
            if field.isChecked {
                fieldsArray.append((field.titleLabel?.text)!)
                fieldsIndex.append(i)
                
            }
        }
        
        for (i, university) in universities.enumerated() {
            if university.isChecked {
                universitiesArray.append((university.titleLabel?.text)!)
                universitiesIndex.append(i)
                
            }
        }
        
        defaults.set(fieldsIndex, forKey: "fields")
        defaults.set(universitiesIndex, forKey: "universities")
        
        delegate?.applyFilter(fields: fieldsArray, universities: universitiesArray)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func out(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

