//
//  SaveStationModel.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/08/31.
//

import Foundation

struct SaveStationModel : Codable{
    let type : type
    let stationName : String
    let updnLine : String
    let line : String
    let lineCode : String
    
    var useLine: String{
        let zeroCut = self.line.replacingOccurrences(of: "0", with: "")
        
        if zeroCut.count < 4 {
            return String(zeroCut[zeroCut.startIndex ..< zeroCut.index(zeroCut.startIndex, offsetBy: zeroCut.count)])
        }else{
            return String(zeroCut[zeroCut.startIndex ..< zeroCut.index(zeroCut.startIndex, offsetBy: 4)])
        }
    }
}

enum type : Codable {
    case bus
    case subway
}
