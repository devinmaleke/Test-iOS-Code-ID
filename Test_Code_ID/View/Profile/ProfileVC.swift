//
//  ProfileVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 09/07/25.
//

import UIKit
import XLPagerTabStrip

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == editProfileButton{
            let editProfileVC = EditProfileVC()
            navigationController?.pushViewController(editProfileVC, animated: true)
        }else if sender == signOutButton{
            
        }
    }
    
    private func initUI(){
        if let currentUser = CurrentUserManager.shared.currentUser {
            nameValueLabel.text = currentUser.name
            emailValueLabel.text = currentUser.email
        }
    }
    
}

extension ProfileVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        return IndicatorInfo(title: "Profile")
    }
}
