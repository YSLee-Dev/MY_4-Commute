//
//  MainTableViewModel.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/11/02.
//

import Foundation

import RxSwift
import RxCocoa

struct MainTableViewModel {
    let stationData = BehaviorRelay<[RealtimeStationArrival]>(value: [])
    let refreshOn = PublishRelay<Void>()
    let editBtnClick = PublishRelay<Bool>()
}
