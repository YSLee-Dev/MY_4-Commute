//
//  FixInfo.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/08/31.
//

import Foundation

struct FixInfo : Codable{
    static var saveStation : [SaveStationModel] = [] {
        didSet{
            let data = try? PropertyListEncoder().encode(self.saveStation)
            UserDefaults.standard.setValue(data, forKey: "saveStation")
        }
    }
}
