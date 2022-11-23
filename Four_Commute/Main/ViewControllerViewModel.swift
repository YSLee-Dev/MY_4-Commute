//
//  ViewControllerModel.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/11/02.
//

import Foundation

import RxSwift
import RxCocoa

class ViewControllerViewModel{
    let mainTableViewModel = MainTableViewModel()
    let viewControllerModel = ViewControllerModel()
    
    let bag = DisposeBag()
    
    let listData = PublishRelay<[RealtimeStationArrival]>()
    let clickCellData : Driver<DetailVCInfo>
    
    init(){
        let clickData = self.mainTableViewModel.clickCell
            .withLatestFrom(self.listData){
                $1[$0.row]
            }
        
        self.clickCellData = self.mainTableViewModel.clickCell
            .withLatestFrom(clickData){
                DetailVCInfo(realInfo: $1, indexPath: $0)
            }
            .asDriver(onErrorDriveWith: .empty())
        
        mainTableViewModel.refreshOn
            .flatMap{
                let stations = self.viewControllerModel.saveStationLoadModel()
                return self.viewControllerModel.stationArrivalRequest(stations: stations)
            }
            .bind(to: self.listData)
            .disposed(by: self.bag)
        
        self.listData
            .bind(to: mainTableViewModel.stationData)
            .disposed(by: self.bag)
    }
}
