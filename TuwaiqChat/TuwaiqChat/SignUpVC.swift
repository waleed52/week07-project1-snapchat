//
//  SignUpVC.swift
//  TuwaiqChat
//
//  Created by PC on 08/04/1443 AH.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setGradientBackground()
    }
    
    
    lazy var profileImage : UIImageView = {
        $0.tintColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "person.circle.fill")
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageAction)))
        $0.isUserInteractionEnabled = true
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    @objc func imageAction() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else {
                // show alert message
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

        profileImage.image = image
        profileImageSuccess = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
 
    
    lazy var fieldsStackView : UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 20
        return $0
    }(UIStackView(arrangedSubviews: [self.nameView, self.emailView, self.passwordView, self.signupButton]))
    
    let nameView : CustomTextFieldView = {
        $0.textField.placeholder = "name"
        return $0
    }(CustomTextFieldView())
    
    let emailView : CustomTextFieldView = {
        $0.textField.placeholder = "email"
        return $0
    }(CustomTextFieldView())
    
    let passwordView : CustomTextFieldView = {
        $0.textField.placeholder = "password"
        $0.textField.isSecureTextEntry = true
        return $0
    }(CustomTextFieldView())
    
    
    let signupButton : UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Sign Up", for: .normal)
        $0.backgroundColor = UIColor(red: 0.92, green: 0.55, blue: 0.55, alpha: 1.00)
        $0.layer.cornerRadius = 20
        $0.tintColor = .darkGray
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))

    
    var nameSuccess = false
    var emailSuccess = false
    var passwordSuccess = false
    var profileImageSuccess = false
    
    @objc func signupAction() {
        if let name = nameView.textField.text, name.isEmpty == false {
            nameSuccess = true
            nameView.layer.shadowColor = UIColor.white.cgColor
        } else {
            // empty
            nameSuccess = false
            nameView.layer.shadowColor = UIColor.red.cgColor
        }
        
        if let email = emailView.textField.text, email.isEmpty == false {
            emailSuccess = true
            emailView.layer.shadowColor = UIColor.white.cgColor
        } else {
            // empty
            emailSuccess = false
            emailView.layer.shadowColor = UIColor.red.cgColor
        }
        
        if let password = passwordView.textField.text, password.isEmpty == false {
            passwordSuccess = true
            passwordView.layer.shadowColor = UIColor.white.cgColor
        } else {
            // empty
            passwordSuccess = false
            passwordView.layer.shadowColor = UIColor.red.cgColor
        }
        
        
        if nameSuccess, emailSuccess, passwordSuccess {
            // firebase signup
            Auth.auth().createUser(withEmail: emailView.textField.text!, password: passwordView.textField.text!) { result, error in
                if error == nil {
                    guard let userID = result?.user.uid else {return}
                    
                    if self.profileImageSuccess {
                        let storage = Storage.storage().reference()
                        let imageRef = storage.child("ProfileImages").child(userID)
                        
                        guard let profileImageData = self.profileImage.image?.pngData() else {return}
                        
                        imageRef.putData(profileImageData, metadata: nil) { meta, error in
                            if error == nil {
                                imageRef.downloadURL { url, error in
                                    if error == nil {
                                        let imageUrlString = url?.absoluteString
                                        
                                        Firestore.firestore().collection("Users").document(userID).setData([
                                            "name" : self.nameView.textField.text!,
                                            "email" : self.emailView.textField.text!,
                                            "id" : userID,
                                            "profileImage" : imageUrlString
                                        ]) { error in
                                            if error == nil {
                                                DispatchQueue.main.async {
                                                    let vc = UINavigationController(rootViewController: MainVC())
                                                    vc.modalTransitionStyle = .crossDissolve
                                                    vc.modalPresentationStyle = .fullScreen
                                                    self.present(vc, animated: true, completion: nil)
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    else {
                        Firestore.firestore().collection("Users").document(userID).setData([
                            "name" : self.nameView.textField.text!,
                            "email" : self.emailView.textField.text!,
                            "id" : userID,
                            "profileImage" : nil
                        ]) { error in
                            if error == nil {
                                DispatchQueue.main.async {
                                    let vc = UINavigationController(rootViewController: MainVC())
                                    vc.modalTransitionStyle = .crossDissolve
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    
                    
                }
            }
        }
        
        
        
    }


}

extension SignUpVC {
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(profileImage)
        view.addSubview(fieldsStackView)
        
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor),
            
            
            fieldsStackView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 60),
            fieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            fieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),

            emailView.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    
    
}

