//
//  StationSearch.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/10/25.
//

import Foundation

import RxSwift
import RxCocoa

enum StationSearchError : Error{
    case networkError
    case jsonError
    case apiError
}

class StationSearch{
    private let session : URLSession
    
    init(session : URLSession = .shared){
        self.session = session
    }
    
    func search(station: String) -> Single<Result<StationModel,StationSearchError>>{
        guard let url = URL(string: ("http://openapi.seoul.go.kr:8088/4a7242674979736c37346143586d63/json/SearchInfoBySubwayNameService/1/5/\(station)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) else { return .just(.failure(.apiError)) }
        let urlString = url.absoluteString.replacingOccurrences(of: "=", with: "")
        
        var request = URLRequest(url: URL(string: urlString) ?? url)
        request.httpMethod = "GET"
        return self.session.rx.data(request: request)
            .map{
                do {
                    let json = try JSONDecoder().decode(StationModel.self, from: $0)
                    return .success(json)
                }catch{
                    return .failure(.jsonError)
                }
            }
            .asSingle()
    }
}
