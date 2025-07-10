//
//  ProfileVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 09/07/25.
//

import UIKit
import XLPagerTabStrip

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ProfileVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        return IndicatorInfo(title: "Profile")
    }
}
