//
//  UserProfileVC.swift
//  TuwaiqChat
//
//  Created by PC on 09/04/1443 AH.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class UserProfileVC : UIViewController {
    
    let db = Firestore.firestore()
    let imagePicker = UIImagePickerController()
    let storage = Storage.storage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupImagePicker()
        readImageFromFirestore()
        
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Users").document(userID).getDocument { document, error in
            if error == nil {
                if let userData = document?.data() {
                    DispatchQueue.main.async {
                        self.userNameLabel.text = userData["name"] as? String
                        self.emailLabel.text = userData["email"] as? String
                    }
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCurrentUsers()
        
    }
    
    
    
    let userImage : UIImageView = {
        $0.tintColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "person.circle.fill")
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
        
        userImage.tintColor = .systemBlue
        userImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        userImage.addGestureRecognizer(tapRecognizer)
        view.addSubview(userImage)
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
    
    func setupImagePicker() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    @objc func imageTapped() {
        print("Image tapped")
        setupImagePicker()
    }
    
    func saveImageToFirestore(url: String, userId: String) {
        
        db.collection("Profiles").document(userId).setData([
            "userImageURL": url,
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    private func readImageFromFirestore(){
        guard let currentUser = Auth.auth().currentUser else {return}
        
        db.collection("Profiles").document(currentUser.uid)
            .addSnapshotListener { (doc, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    let data = doc?.data()
                    
                    if let imageURL = data?["userImageURL"] as? String
                    {
                        
                        let httpsReference = self.storage.reference(forURL: imageURL)
                        
                        
                        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                                print("ERROR GETTING DATA \(error.localizedDescription)")
                            } else {
                                // Data for "images/island.jpg" is returned
                                
                                DispatchQueue.main.async {
                                    self.userImage.image = UIImage(data: data!)
                                }
                                
                            }
                        }
                        
                    } else {
                        
                        print("error converting data")
                        DispatchQueue.main.async {
                            self.userImage.image = UIImage(systemName: "person.fill.badge.plus")
                        }
                        
                    }
                    
                }
            }
    }
    
    
    
    private func fetchCurrentUsers() {
        guard let currentUserName = FirebaseAuth.Auth.auth().currentUser else {return}
        db.collection("Profiles").whereField("email", isEqualTo: String(currentUserName.email!))
            .addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let userName = data["name"] as? String,
                               let userIsOnline = data["status"] as? String,
                               let userEmail = data["email"] as? String
                            {
                                
                                
                                DispatchQueue.main.async {
                                    self.userNameLabel.text = userName
                                    self.emailLabel.text = userEmail
                                    if userIsOnline == "yes" {
                                        
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
        
        
    }
}
extension UserProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        guard let d: Data = userPickedImage.jpegData(compressionQuality: 0.5) else { return }
        guard let currentUser = Auth.auth().currentUser else {return}
        
        
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        let ref = storage.reference().child("UserProfileImages/\(currentUser.email!)/\(currentUser.uid).jpg")
        
        ref.putData(d, metadata: metadata) { (metadata, error) in
            if error == nil {
                ref.downloadURL(completion: { (url, error) in
                    self.saveImageToFirestore(url: "\(url!)", userId: currentUser.uid)
                    
                })
            }else{
                print("error \(String(describing: error))")
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}
