//
//  PageViewController.swift
//  THEAPP
//
//  Created by Ada 2018 on 19/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    weak var onboardingDelegate: OnboardingViewControllerDelegate?
    var string = "String"
    var academicView : AcademicViewController?
    var personalView : PersonalViewController?
    
    lazy var orderedViewController: [UIViewController] = {
        return [instantiatePV1(),
                instantiatePV2()]
    }()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        print("viewControllerBefore")
        
//        if viewController.restorationIdentifier == "academicPage" {
//            return instantiatePV1()
//        } else {
//            onboardingDelegate?.onboardingPageViewController(onboardingPageViewController: self, didUpdatePageIndex: 0)
//            return nil
//        }
        
        guard let viewControllerIndex = orderedViewController.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        onboardingDelegate?.onboardingPageViewController(onboardingPageViewController: self, didUpdatePageIndex: previousIndex)
        guard previousIndex >= 0 else {
            return nil
        }
        return orderedViewController[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        if viewController.restorationIdentifier == "personalPage" {
//            return instantiatePV2()
//        } else {
//            onboardingDelegate?.onboardingPageViewController(onboardingPageViewController: self, didUpdatePageIndex: 1)
//            return nil
//        }
        guard let viewControllerIndex = orderedViewController.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        onboardingDelegate?.onboardingPageViewController(onboardingPageViewController: self, didUpdatePageIndex: nextIndex)

        guard nextIndex < orderedViewController.count else {
            return nil
        }
        return orderedViewController[nextIndex]
    }
    
    func instantiatePV1() -> UIViewController {
        //        onboardingDelegate?.onboardingPageViewController(onboardingPageViewController: self, didUpdatePageIndex: 0)
        let view = storyboard?.instantiateViewController(withIdentifier: "personalPage")
        personalView = view as? PersonalViewController
        return view!
    }
    
    func instantiatePV2() -> UIViewController {
        //        onboardingDelegate?.onboardingPageViewController(onboardingPageViewController: self, didUpdatePageIndex: 1)
        let view = storyboard?.instantiateViewController(withIdentifier: "academicPage")
        academicView = view as? AcademicViewController
        return view!
    }
    
    func nextPageWithIndex(index: Int) {
        setViewControllers([orderedViewController[index]], direction: .forward, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        onboardingDelegate?.onboardingPageViewController(onboardingPageViewController: self, didUpdatePageCount: orderedViewController.count)

        if let firstViewController = orderedViewController.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    

}

protocol OnboardingViewControllerDelegate: class {
    func onboardingPageViewController(onboardingPageViewController: PageViewController, didUpdatePageCount count: Int)
    func onboardingPageViewController(onboardingPageViewController: PageViewController, didUpdatePageIndex index: Int)
}
