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
    
    // lazy var editBtn = UIBarButtonItem(title: "편집", style: .done, target: self, action: #selector(editBtnClick))
    
    var stationArrival = StationArrival()
    var saveStationLoad = SaveStationLoad()
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSet()
        self.bind()
        self.dataBind()
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
    
    func dataBind(){
        let stations = self.saveStationLoad.stationLoad()
            .asObservable()
            .flatMap{ data -> Observable<SaveStationModel> in
                guard case .success(let value) = data else {return .never()}
                return Observable.from(value)
            }
            .share()
        
        let arrivalData = stations
            .concatMap { station in
                self.stationArrival.stationArrivalRequest(stationName: station.stationName)
            }
            .map{ data -> LiveStationModel? in
                guard case .success(let value) = data else {return nil}
                return value
            }
            .filter{$0 != nil}
        
       let data = Observable
            .zip(stations, arrivalData){ station, data -> RealtimeStationArrival in
                for x in data!.realtimeArrivalList{
                    if station.lineCode == x.subWayId && station.updnLine == x.upDown && station.stationName == x.stationName{
                        return RealtimeStationArrival(upDown: x.upDown, arrivalTime: x.upDown, previousStation: x.previousStation, subPrevious: x.subPrevious, code: x.code, subWayId: x.subWayId, isFast: x.isFast, stationName: x.stationName, lineNumber: station.line, useLine: station.useLine)
                    }
                }
                
                return  RealtimeStationArrival(upDown: station.updnLine, arrivalTime: "", previousStation: "", subPrevious: "", code: "", subWayId: "", isFast: "X", stationName: station.stationName, lineNumber: station.line, useLine: station.useLine)
            }
            .toArray()
            .asObservable()
            .share()
        
        data
            .bind(to: self.mainTableView.stationData)
            .disposed(by: self.bag)
            
        self.mainTableView.refreshOn
            .withLatestFrom(data)
            .bind(to: self.mainTableView.stationData)
            .disposed(by: self.bag)
    }
    
    func bind(){
        self.mainTableView.refreshOn
            .subscribe(onNext: {
                self.dataBind()
            })
            .disposed(by: self.bag)
    }
    
    /*
    
    @objc func editBtnClick(){
        if self.mainTableView.mainTableView.isEditing {
            self.mainTableView.mainTableView.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "편집"
        }else{
            self.mainTableView.mainTableView.setEditing(true, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "완료"
        }
        self.mainTableView.mainTableView.reloadData()
    }
     */
}
/*
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\(self.realInfo.count)번 환승"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.realInfo.remove(at: indexPath.row)
            FixInfo.saveStation.remove(at: indexPath.row)
            self.mainTableView.mainTableView.deleteRows(at: [indexPath], with: .left)
        }
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
