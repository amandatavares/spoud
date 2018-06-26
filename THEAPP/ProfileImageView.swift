//
//  ProfileImageView.swift
//  THEAPP
//
//  Created by Ada 2018 on 18/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

struct Const {
    static let ImageSizeForLargeState: CGFloat = 50
    static let ImageRightMargin: CGFloat = 16
    static let ImageBottomMarginForLargeState: CGFloat = 10
    static let ImageBottomMarginForSmallState: CGFloat = 6
    static let ImageSizeForSmallState: CGFloat = 30
    static let NavBarHeightSmallState: CGFloat = 44
    static let NavBarHeightLargeState: CGFloat = 96.5
}

class ProfileImageView: UIImageView {

    
    func gradientBorder() {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: self.frame.size)
        let topColor = #colorLiteral(red: 0.003921568627, green: 0.4156862745, blue: 0.6823529412, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.337254902, green: 0.6352941176, blue: 0.8941176471, alpha: 1)
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        
        let border = CAGradientLayer()
        border.frame =  CGRect(origin: .zero, size: self.frame.size)
        let topColor2 = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
        let bottomColor2 = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
        border.colors = [topColor2.cgColor, bottomColor2.cgColor]
        
        let radius = self.layer.cornerRadius
        
        let shape2 = CAShapeLayer()
        shape2.lineWidth = 8
        shape2.path = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath
        shape2.strokeColor = UIColor.black.cgColor
        shape2.fillColor = UIColor.clear.cgColor
        border.mask = shape2
        
        
        let shape = CAShapeLayer()
        shape.lineWidth = 5
        shape.path = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
        self.layer.insertSublayer(border, below: gradient)
    }
    
    
    func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        self.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.alpha = show ? 1.0 : 0.0
        }
    }
    
    func setupUI(controller: UIViewController) {
        controller.navigationController?.navigationBar.prefersLargeTitles = true
        controller.navigationController?.navigationBar.shadowImage = UIImage()
        
        guard let navigationBar = controller.navigationController?.navigationBar else {return}
        
        navigationBar.addSubview(self)
        
        self.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                        constant: -Const.ImageRightMargin),
            self.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                         constant: -Const.ImageBottomMarginForLargeState),
            self.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            self.widthAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState)
            ])
    }
    

}
