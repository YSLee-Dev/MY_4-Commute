//
//  ViewController.swift
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

class ViewController: UIViewController {
    
    var mainTableView = MainTableView()
    
    let nowDate : String = {
        let DataFormmater = DateFormatter()
        DataFormmater.locale = Locale(identifier: "ko_kr")
        DataFormmater.dateFormat = "EEEE"
        
        return DataFormmater.string(from: Date())
    }()
    
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSet()
    }
    
    
    func bind(viewModel : ViewControllerViewModel){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: .done, target: self, action: nil)
        
        self.mainTableView.bind(viewModel: viewModel.mainTableViewModel)
        
        viewModel.mainTableViewModel.refreshOn
            .accept(Void())

        
        self.navigationItem.rightBarButtonItem?.rx.tap
            .map{ _ -> Bool in
                if self.navigationItem.rightBarButtonItem!.title == "편집"{
                    self.navigationItem.rightBarButtonItem!.title = "완료"
                    return true
                }else{
                    self.navigationItem.rightBarButtonItem!.title = "편집"
                    return false
                }
            }
            .bind(to: viewModel.mainTableViewModel.editBtnClick)
            .disposed(by: self.bag)
    }
}

private extension ViewController {
    func viewSet(){
        self.navigationItem.title = "\(self.nowDate)도 화이팅"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.addSubview(self.mainTableView)
        self.mainTableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
/*
 extension ViewController : UITableViewDelegate, UITableViewDataSource{
 
 func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
 "\(self.realInfo.count)번 환승"
 }
 
 func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 true
 }
 
 func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
 let realOldData = self.realInfo[sourceIndexPath.row]
 self.realInfo[sourceIndexPath.row] = self.realInfo[destinationIndexPath.row]
 self.realInfo[destinationIndexPath.row] = realOldData
 let StationOldData = FixInfo.saveStation[sourceIndexPath.row]
 FixInfo.saveStation[sourceIndexPath.row] = FixInfo.saveStation[destinationIndexPath.row]
 FixInfo.saveStation[destinationIndexPath.row] = StationOldData
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 self.navigationController?.pushViewController(DetailVC(info: self.realInfo[indexPath.row], index: indexPath), animated: true)
 }
 }
 
 */
