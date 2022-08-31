//
//  TabbarVC.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/08/30.
//

import UIKit

import Then

class TabbarVC : UITabBarController {
    
    let mainVC = ViewController().then{
        $0.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
    }
    
    let searchVC = SearchVC().then{
        $0.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
    }
    
    override func viewDidLoad() {
        self.viewControllers = [UINavigationController(rootViewController: self.mainVC), UINavigationController(rootViewController: self.searchVC)]
    }
}
