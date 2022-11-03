//
//  SearchViewModel.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/11/03.
//

import Foundation

import RxSwift
import RxCocoa

class SearchViewModel{
    let searchBarViewModel = SearchBarViewModel()
    let resultViewModel = ResultViewModel()
    
    let stationSearch = StationSearch()
    
    let bag = DisposeBag()
    
    init(){
        searchBarViewModel.searchBarText
            .filter{$0 != nil}
            .flatMapLatest{
                self.stationSearch.search(station: $0!)
            }
            .map{ data -> StationModel? in
                guard case .success(let value) = data else{
                    return nil
                }
                return value
            }
            .filter{$0 != nil}
            .map{ stationModel -> [row] in
               stationModel!.SearchInfoBySubwayNameService.row
            }
            .asSignal(onErrorJustReturn: [])
            .emit(to: resultViewModel.resultRow)
            .disposed(by: self.bag)
    }
}
