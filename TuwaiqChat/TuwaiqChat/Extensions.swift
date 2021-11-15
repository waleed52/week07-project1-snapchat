//
//  Extensions.swift
//  TuwaiqChat
//
//  Created by PC on 08/04/1443 AH.
//

import UIKit

extension UIViewController {
    func setGradientBackground() {
        let colorTop = UIColor(red: 0.35, green: 0.64, blue: 0.73, alpha: 1.00).cgColor
        let colorBottom = UIColor.black.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}


