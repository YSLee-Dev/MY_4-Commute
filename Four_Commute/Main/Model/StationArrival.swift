//
//  StationArrival.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/10/26.
//

import Foundation

import RxSwift
import RxCocoa

enum arrivalError : Error{
    case jsonError
    case networkError
    case urlError
}

class StationArrival{
    private var session : URLSession
    
    init(session : URLSession = .shared){
        self.session = session
    }
    
    func stationArrivalRequest(stationName : String) -> Single<Result<LiveStationModel, arrivalError>>{
        guard let url = URL(string: "http://swopenapi.seoul.go.kr/api/subway/524365677079736c313034597a514e41/json/realtimeStationArrival/0/10/\(stationName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {return .just(.failure(.urlError))}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return self.session.rx.data(request: request)
            .map{
                do {
                    let json = try JSONDecoder().decode(LiveStationModel.self, from: $0)
                    return .success(json)
                }catch{
                    return .failure(.jsonError)
                }
            }
            .asSingle()
    }
}
