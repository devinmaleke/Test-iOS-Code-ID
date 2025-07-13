//
//  TabBarVC.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 09/07/25.
//

import UIKit
import XLPagerTabStrip

class TabBarVC: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {

        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .black
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 1.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex else { return }
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = .black
        }
        
        super.viewDidLoad()
        
        self.containerView.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topInset = view.safeAreaInsets.top
    
        var barFrame = buttonBarView.frame
        barFrame.origin.y = topInset
        buttonBarView.frame = barFrame

        var containerFrame = containerView.frame
        containerFrame.origin.y = buttonBarView.frame.maxY
        containerFrame.size.height = view.bounds.height - containerFrame.origin.y
        containerView.frame = containerFrame
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let homeVC = HomeVC()
        let profileVC = ProfileVC()
        return [homeVC, profileVC]
    }
}
