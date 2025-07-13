//
//  ProfileVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 09/07/25.
//

import UIKit
import RxSwift
import XLPagerTabStrip

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == editProfileButton{
            let editProfileVC = EditProfileVC()
            editProfileVC.didUpdate
                .bind { [weak self] in
                    self?.initUI()
                }
                .disposed(by: disposeBag)
            navigationController?.pushViewController(editProfileVC, animated: true)
        }else if sender == signOutButton{
            logout()
        }
    }
    
    private func initUI(){
        if let currentUser = CurrentUserManager.shared.currentUser {
            nameValueLabel.text = currentUser.name
            emailValueLabel.text = currentUser.email
        }
    }
    
    private func logout() {
        CurrentUserManager.shared.setCurrentUser(nil)
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: ViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
            }
        }
    }
    
}

extension ProfileVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        return IndicatorInfo(title: "Profile")
    }
}
