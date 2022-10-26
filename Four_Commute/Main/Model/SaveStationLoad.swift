//
//  SaveStationLoad.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/10/26.
//

import Foundation

import RxSwift
import RxCocoa

enum SaveStationError : Error{
    case decoderError
    case udError
}

struct SaveStationLoad{
    func stationLoad() -> Single<Result<[SaveStationModel], SaveStationError>>{
        let udValue = UserDefaults.standard.value(forKey: "saveStation")
        guard let data = udValue as? Data else {return .just(.failure(.udError))}
        
        do {
            let list = try PropertyListDecoder().decode([SaveStationModel].self, from: data)
            FixInfo.saveStation = list
            return .just(.success(list))
        }catch{
            print(error)
            return .just(.failure(.decoderError))
        }
    }
}
