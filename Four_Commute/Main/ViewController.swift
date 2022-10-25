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
    
    lazy var mainTableView = MainTableView().then{
        $0.mainTableView.delegate = self
        $0.mainTableView.dataSource = self
    }
    
    let nowDate : String = {
        let DataFormmater = DateFormatter()
        DataFormmater.locale = Locale(identifier: "ko_kr")
        DataFormmater.dateFormat = "EEEE"
        
        return DataFormmater.string(from: Date())
    }()
    
    lazy var refresh = UIRefreshControl().then{
        $0.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        $0.backgroundColor = .white
        $0.attributedTitle = NSAttributedString("당겨서 새로고침")
    }
    
    lazy var editBtn = UIBarButtonItem(title: "편집", style: .done, target: self, action: #selector(editBtnClick))
    
    var realInfo : [RealtimeStationArrival] = []
    
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.saveStationSet()
        self.fetchData()
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
        
        self.mainTableView.mainTableView.refreshControl = self.refresh
        self.navigationItem.rightBarButtonItem = self.editBtn
    }
    
    func saveStationSet(){
        guard let udValue = UserDefaults.standard.value(forKey: "saveStation") else {return}
        guard let data = udValue as? Data else {return}
        do {
            let list = try PropertyListDecoder().decode([SaveStationModel].self, from: data)
            FixInfo.saveStation = list
           
            self.realInfo = []
            list.forEach{ [weak self] _ in
                self?.realInfo.append(RealtimeStationArrival(upDown: "", arrivalTime: "", previousStation: "", subPrevious: "", code: "", subWayId: "", isFast: nil))
            }
            
            self.mainTableView.mainTableView.reloadData()
            
        }catch{
            print(error)
        }
    }
    
    func rxReqeustData(rxObservable : Observable<SaveStationModel>){
        
        let list = rxObservable
        
        let request = rxObservable
            .map{ model -> URL? in
                let urlString = "http://swopenapi.seoul.go.kr/api/subway/524365677079736c313034597a514e41/json/realtimeStationArrival/0/10/\(model.stationName.replacingOccurrences(of: "역", with: ""))".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                return URL(string: urlString ?? "") ?? nil
            }
            .filter{
                $0 != nil
            }
            .map{ url -> URLRequest in
                var request = URLRequest(url: url!)
                request.httpMethod = "GET"
                return request
            }
            .concatMap{ request -> Observable<(response : HTTPURLResponse, data : Data)> in
                URLSession.shared.rx.response(request: request)
            }
            .filter{ response, _ in
                200..<300 ~= response.statusCode
            }
            .map{ _, data -> LiveStationModel? in
                do{
                    let json = try JSONDecoder().decode(LiveStationModel.self, from: data)
                    return json
                }catch{
                    print(error)
                    return nil
                }
            }
            .filter{
                $0 != nil
            }
        
       Observable
            .zip(list, request){ list, request -> RealtimeStationArrival? in
                guard let live = request else {return nil}
                for x in live.realtimeArrivalList{
                    if list.lineCode == x.subWayId && list.updnLine == x.upDown{
                        return x
                    }
                }
                return nil
            }
            .observe(on: MainScheduler.instance)
            .filter{
                $0 != nil
            }
            .enumerated()
            .subscribe(onNext: { index, data in
                self.realInfo[index] = data!
                self.mainTableView.mainTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .left)
            })
            .disposed(by: bag)
        
    }
    
    @objc func fetchData(){
        self.refresh.endRefreshing()
        rxReqeustData(rxObservable: Observable.from(FixInfo.saveStation))
    }
    
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
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.realInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        cell.cellSet(margin: Int(self.navigationController?.systemMinimumLayoutMargins.leading ?? 0))
        cell.station.text = "\(FixInfo.saveStation[indexPath.row].stationName) | \(FixInfo.saveStation[indexPath.row].updnLine)"
        cell.line.text =  FixInfo.saveStation[indexPath.row].useLine

        cell.arrivalTime.text = "\(self.realInfo[indexPath.row].useTime)"
        cell.now.text = "\(self.realInfo[indexPath.row].useFast)\(self.realInfo[indexPath.row].previousStation)\(self.realInfo[indexPath.row].useCode)"
        cell.lineColor(line: FixInfo.saveStation[indexPath.row].line)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
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
