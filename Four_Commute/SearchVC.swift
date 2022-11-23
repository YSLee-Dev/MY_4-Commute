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
    let resultVC = ResultVC()

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        self.viewSet()
    }
}

extension SearchVC{
    private func viewSet(){
        self.navigationItem.searchController = self.searchVC
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "검색"
        
    }
    
    func bind(viewModel : SearchViewModel){
        self.searchVC = SearchBarVC(searchResultsController: self.resultVC)
        
        self.resultVC.bind(viewModel: viewModel.resultViewModel)
        self.searchVC!.bind(viewModel: viewModel.searchBarViewModel)
        
        viewModel.resultViewModel.clickRow
            .subscribe(onNext: {
                self.updownAlert(row: $0)
            })
            .disposed(by: self.bag)
        
    }
    
    func updownAlert(row : row){
        let title = row.useLine == "2호선" ? "내선/외선" : "상하행선"
        
        let up = title == "내선/외선" ? "내선" : "상행"
        let down = title == "내선/외선" ? "외선" : "하행"
        
        let alert = UIAlertController(title: "\(title)을 선택해주세요.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: up, style: .destructive){ _ in
            FixInfo.saveStation.append(SaveStationModel(type: .subway, stationName: row.stationName.replacingOccurrences(of: "역", with: ""), updnLine: up, line: row.lineNumber.rawValue, lineCode: row.lineCode))
            })
        alert.addAction(UIAlertAction(title: down, style: .default){ _ in
        FixInfo.saveStation.append(SaveStationModel(type: .subway, stationName: row.stationName.replacingOccurrences(of: "역", with: ""), updnLine: down, line: row.lineNumber.rawValue, lineCode: row.lineCode))
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
}

