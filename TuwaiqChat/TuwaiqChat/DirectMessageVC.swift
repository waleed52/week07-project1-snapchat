//
//  DirectMessageVC.swift
//  TuwaiqChat
//
//  Created by PC on 09/04/1443 AH.
//

import UIKit

class DirectMessageVC : UIViewController {
    
    var user : User?
    
    var messages = [
        "السلام عليكم",
        "و عليكم السلام اهلا",
        "كيف الحال ؟",
        "و الله الحمد لله تمام التمام",
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.title = user?.name
        setGradientBackground()
        
        view.addSubview(messagesTableView)
        
        NSLayoutConstraint.activate([
            messagesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messagesTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            messagesTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    lazy var messagesTableView : UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(MessageCell.self, forCellReuseIdentifier: "Cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        return $0
    }(UITableView())
    
    
}


extension DirectMessageVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageCell
        
        if indexPath.row % 2 == 0 {
            cell.MainViewTrailingAnchor.isActive = true
            cell.MainViewLeadingAnchor.isActive = false
            cell.mainView.backgroundColor = .init(white: 0.90, alpha: 0.5)
            cell.messageLabel.textColor = .black
        } else {
            cell.MainViewTrailingAnchor.isActive = false
            cell.MainViewLeadingAnchor.isActive = true
            cell.mainView.backgroundColor = UIColor(red: 0.17, green: 0.32, blue: 0.36, alpha: 1.00)
            cell.messageLabel.textColor = .white
        }
        
        cell.messageLabel.text = messages[indexPath.row]
        return cell
    }
    
    
}
