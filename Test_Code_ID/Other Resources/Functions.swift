//
//  Functions.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 09/07/25.
//

import UIKit

class Functions{
    static func securedField(textField: UITextField, sender: UIButton){
        if textField.isSecureTextEntry == true{
            sender.setImage(UIImage(named: "eye"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "eye-close"), for: .normal)
        }
        textField.isSecureTextEntry.toggle()
    }
}
