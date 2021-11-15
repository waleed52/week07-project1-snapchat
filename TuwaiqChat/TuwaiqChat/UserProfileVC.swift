//
//  UserProfileVC.swift
//  TuwaiqChat
//
//  Created by PC on 09/04/1443 AH.
//

import UIKit
import Firebase
import SDWebImage

class UserProfileVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Users").document(userID).getDocument { document, error in
            if error == nil {
                if let userData = document?.data() {
                    DispatchQueue.main.async {
                        self.userNameLabel.text = userData["name"] as? String
                        self.emailLabel.text = userData["email"] as? String
                        
                        if let profileImage = userData["profileImage"] as? String {
                            
                            let imageURL = URL(string: profileImage)
                            
                            self.userImage.sd_setImage(with: imageURL) { image, error, cache, url in
                                if error == nil {
                                    DispatchQueue.main.async {
                                        self.userImage.image = image
                                    }
                                }
                            }
                            
                        } else {
                            self.userImage.image = UIImage(systemName: "person.circle.fill")
                        }
                        
                    }
                }
            }
        }
        
    }
    
    
    let userImage : UIImageView = {
        $0.tintColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    
    let userNameLabel : UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.textColor = .white
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    let emailLabel : UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .white
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
}

extension UserProfileVC {
    func setupUI() {
        setGradientBackground()
        
        view.backgroundColor = .white
        
        view.addSubview(userImage)
        view.addSubview(userNameLabel)
        view.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImage.heightAnchor.constraint(equalToConstant: 100),
            userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            emailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emailLabel.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
}
