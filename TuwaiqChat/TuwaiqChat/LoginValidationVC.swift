//
//  LoginValidationVC.swift
//  TuwaiqChat
//
//  Created by PC on 09/04/1443 AH.
//

import UIKit
import Firebase

class LoginValidationVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground()
        
        if Auth.auth().currentUser?.uid != nil {
            // go to MainVC
            let vc = UINavigationController(rootViewController: MainVC())
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        else {
            // go to SignInVC
            let vc = UINavigationController(rootViewController: SignInVC())
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
}
