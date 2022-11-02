//
//  ViewControllerModel.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/11/02.
//

import Foundation

import RxSwift
import RxCocoa

struct ViewControllerViewModel{
    let mainTableViewModel = MainTableViewModel()
    
    var stationArrival = StationArrival()
    var saveStationLoad = SaveStationLoad()
    
    func saveStationLoadModel() -> Observable<SaveStationModel>{
        self.saveStationLoad.stationLoad()
            .asObservable()
            .flatMap{ data -> Observable<SaveStationModel> in
                guard case .success(let value) = data else {return .never()}
                return Observable.from(value)
            }
    }
    
    func stationArrivalRequest(stations : Observable<SaveStationModel>) -> Observable<[RealtimeStationArrival]>{
        let arrival = stations
            .concatMap { station in
                self.stationArrival.stationArrivalRequest(stationName: station.stationName)
            }
            .map{ data -> LiveStationModel? in
                guard case .success(let value) = data else {return nil}
                return value
            }
            .filter{$0 != nil}
        
        return Observable
            .zip(stations, arrival){ station, data -> RealtimeStationArrival in
                for x in data!.realtimeArrivalList{
                    if station.lineCode == x.subWayId && station.updnLine == x.upDown && station.stationName == x.stationName{
                        return RealtimeStationArrival(upDown: x.upDown, arrivalTime: x.upDown, previousStation: x.previousStation, subPrevious: x.subPrevious, code: x.code, subWayId: x.subWayId, isFast: x.isFast, stationName: x.stationName, lineNumber: station.line, useLine: station.useLine)
                    }
                }
                
                return  RealtimeStationArrival(upDown: station.updnLine, arrivalTime: "", previousStation: "", subPrevious: "", code: "", subWayId: "", isFast: "X", stationName: station.stationName, lineNumber: station.line, useLine: station.useLine)
            }
            .toArray()
            .asObservable()
    }
}
