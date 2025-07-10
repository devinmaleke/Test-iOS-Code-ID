//
//  HomeDetailVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 11/07/25.
//

import UIKit

class HomeDetailVC: UIViewController {

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var abilitiesValue: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == backButton {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
