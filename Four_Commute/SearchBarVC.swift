//
//  SearchBarVC.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/10/25.
//

import UIKit

import RxCocoa
import RxSwift

class SearchBarVC : UISearchController{
    
    let bag = DisposeBag()
    let searchBarText = PublishSubject<String?>()
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        self.bind()
        self.attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchBarVC {
    func bind(){
        self.searchBar.rx.text
            .asSignal(onErrorJustReturn: "")
            .distinctUntilChanged()
            .emit(to: self.searchBarText)
            .disposed(by: self.bag)
    }
    
    func attribute(){
        self.searchBar.placeholder = "지하철역을 입력하세요."
    }
}
