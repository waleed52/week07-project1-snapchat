//
//  CustomTextField.swift
//  TuwaiqChat
//
//  Created by PC on 08/04/1443 AH.
//

import UIKit

class CustomTextFieldView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        backgroundColor = UIColor(red: 0.21, green: 0.40, blue: 0.45, alpha: 1.00)

        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        
        self.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
        ])
    }
    
    let textField : UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .white
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.layer.cornerRadius = 20
        $0.textAlignment = .center
        $0.attributedPlaceholder = NSAttributedString(
            string: "Placeholder Text",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        return $0
    }(UITextField())
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
