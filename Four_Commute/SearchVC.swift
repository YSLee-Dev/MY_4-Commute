//
//  SearchVC.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/08/30.
//

import UIKit

import SnapKit
import Then
import Alamofire
import RxSwift
import RxCocoa

class SearchVC : UIViewController{
    var searchVC : SearchBarVC?
    
    let stationSearch = StationSearch()
    let resultVC = ResultVC()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        self.viewSet()
        self.bind()
    }
}

private extension SearchVC{
    func viewSet(){
        self.searchVC = SearchBarVC(searchResultsController: self.resultVC)
        self.navigationItem.searchController = self.searchVC
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "검색"
        
    }
    
    func bind(){
        self.searchVC!.searchBarText
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
            .emit(to: self.resultVC.resultRow)
            .disposed(by: self.bag)
    }
    
}
