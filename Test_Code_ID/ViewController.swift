//
//  ViewController.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 09/07/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let loginVC = LoginVC()
        navigationController?.pushViewController(loginVC, animated: false)
    }


}

