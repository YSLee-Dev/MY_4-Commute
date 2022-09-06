//
//  LiveStationModel.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/08/31.
//

import Foundation

struct LiveStationModel : Decodable{
    let realtimeArrivalList : [RealtimeStationArrival]
}

struct RealtimeStationArrival : Decodable{
    let upDown : String
    let arrivalTime : String
    let previousStation : String
    let subPrevious : String
    let code : String
    let subWayId : String
    
    enum CodingKeys : String, CodingKey{
        case upDown = "updnLine"
        case arrivalTime = "barvlDt"
        case previousStation = "arvlMsg3"
        case subPrevious = "arvlMsg2"
        case code = "arvlCd"
        case subWayId = "subwayId"
    }
    
    var useCode : String{
        switch code {
        case "0":
            return "진입"
        case "1":
            return "도착"
        case "2":
            return "출발"
        case "3":
            return "출발"
        case "4":
            return "진입"
        case "5":
            return "도착"
        case "99":
            return "도착"
        default:
            return ""
        }
    }
    
    var useTime : String{
        let time = Int(self.arrivalTime) ?? 0
        let min = Int((time/60))
        
        if min == 0{
            if time == 0{
                return self.subPrevious
            }else{
                return "\(time)초"
            }
        }else{
            return "\(min)분"
        }
        
        
    }
}
