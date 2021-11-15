//
//  CustomCell.swift
//  TuwaiqChat
//
//  Created by PC on 08/04/1443 AH.
//

import UIKit

class CustomCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(mainView)
        mainView.addSubview(nameLabel)
        mainView.addSubview(userImage)
        
        NSLayoutConstraint.activate([
            
            mainView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            mainView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            mainView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: mainView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: userImage.leadingAnchor),
                        
            userImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            userImage.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10),
            userImage.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            userImage.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            userImage.heightAnchor.constraint(equalToConstant: 60),
            userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor)
        
        ])
    }
    
    let mainView : UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(red: 0.17, green: 0.33, blue: 0.37, alpha: 1.00)
        $0.layer.shadowColor = UIColor.white.cgColor
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowOffset = CGSize.zero
        $0.layer.shadowRadius = 3
        $0.layer.cornerRadius = 10
        return $0
    }(UIView())
    
    
    let nameLabel : UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .init(white: 0.95, alpha: 1)
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        return $0
    }(UILabel())
    
    
    let userImage : UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "person.circle.fill")
        $0.tintColor = .init(white: 0.85, alpha: 1)
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.borderColor = UIColor.init(white: 0.90, alpha: 1).cgColor
        $0.layer.borderWidth = 1
        return $0
    }(UIImageView())
    
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
