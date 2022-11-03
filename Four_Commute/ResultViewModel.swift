//
//  ResultViewModel.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/11/03.
//

import Foundation

import RxSwift
import RxCocoa

struct ResultViewModel{
    let resultRow = PublishRelay<[row]>()
    let clickRow = PublishRelay<row>()
}
