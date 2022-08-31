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

class SearchVC : UIViewController{
    lazy var searchVC = UISearchController(searchResultsController: ResultVC()).then{
        $0.searchBar.placeholder = "지하철역을 입력하세요."
        $0.searchResultsUpdater = self
    }
    
    override func viewDidLoad() {
        self.viewSet()
    }
}

private extension SearchVC{
    func viewSet(){
        self.navigationItem.searchController = self.searchVC
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "검색"
    }
    
    func requestData(name : String, resultVC : ResultVC){
        let stringUrl = "http://openapi.seoul.go.kr:8088/4a7242674979736c37346143586d63/json/SearchInfoBySubwayNameService/1/5/\(name)"
        print(stringUrl)
        AF.request(stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "").responseDecodable(of: StationModel.self){ response in
            switch response.result{
            case let .success(data):
                resultVC.row = data.SearchInfoBySubwayNameService.row
            case let .failure(error):
                resultVC.row = nil
                print(error)
            }
        }
    }
}

extension SearchVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        if text != ""{
            guard let vc = searchController.searchResultsController as? ResultVC else {return}
            self.requestData(name: text, resultVC: vc)
        }
        
    }
}
