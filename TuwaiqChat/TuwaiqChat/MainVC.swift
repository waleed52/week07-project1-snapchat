//
//  MainVC.swift
//  TuwaiqChat
//
//  Created by PC on 08/04/1443 AH.
//

import UIKit
import Firebase
import SDWebImage

class MainVC : UIViewController {
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getAllUsers()
        
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .plain, target: self, action: #selector(showProfile))
        navigationItem.rightBarButtonItem = profileButton
    }
    
    @objc func showProfile() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(UserProfileVC(), animated: true)
    }
    
    let searchBar : CustomTextFieldView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textField.placeholder = "search..."
        $0.textField.textAlignment = .left
        return $0
    }(CustomTextFieldView())
    
    
    lazy var usersTableView : UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(CustomCell.self, forCellReuseIdentifier: "Cell")
        $0.backgroundColor = .clear
        return $0
    }(UITableView())
    
    
    func getAllUsers() {
        Firestore.firestore().collection("Users").addSnapshotListener { snapshot, error in
            if error == nil {
                if let value = snapshot?.documents {
                    for user in value {
                        let userData = user.data()
                        
                            
                            self.users.append(User(id: userData["id"] as? String, name: userData["name"] as? String, email: userData["email"] as? String, profileImage: userData["profileImage"] as? String))
                    }
                }
                self.usersTableView.reloadData()
            }
        }
    }
}


extension MainVC {
    func setupUI () {
        
        navigationItem.title = "Contacts"
        setGradientBackground()
        
        view.addSubview(searchBar)
        view.addSubview(usersTableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            usersTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            usersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


extension MainVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.nameLabel.text = users[indexPath.row].name

        if let imageURL = users[indexPath.row].profileImage {
            cell.userImage.sd_setImage(with: URL(string: imageURL), completed: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DirectMessageVC()
        vc.user = users[indexPath.row]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
