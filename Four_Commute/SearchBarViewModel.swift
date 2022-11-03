//
//  SearchBarViewModel.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/11/03.
//

import Foundation

import RxSwift

struct SearchBarViewModel {
    let searchBarText = PublishSubject<String?>()
}
