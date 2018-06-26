//
//  SignUpViewController.swift
//  THEAPP
//
//  Created by Ada 2018 on 19/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, OnboardingViewControllerDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    var signUpPage : PageViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onboardingViewController = segue.destination as? PageViewController {
            signUpPage = onboardingViewController
            onboardingViewController.onboardingDelegate = self
        }
    }
    
    func onboardingPageViewController(onboardingPageViewController: PageViewController, didUpdatePageCount count: Int) {
        print("Count: \(count)")
        pageControl.numberOfPages = count
    }
    
    func onboardingPageViewController(onboardingPageViewController: PageViewController, didUpdatePageIndex index: Int) {
        print("Index: \(index)")
        pageControl.currentPage = index
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
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
