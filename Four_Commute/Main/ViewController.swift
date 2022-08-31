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

class ViewController: UIViewController {
    
    lazy var mainTableView = MainTableView().then{
        $0.mainTableView.delegate = self
        $0.mainTableView.dataSource = self
    }
    
    let nowDate : String = {
        let DataFormmater = DateFormatter()
        DataFormmater.dateFormat = "EEEE"
        
        return DataFormmater.string(from: Date())
    }()
    
    var realInfo : [RealtimeStationArrival] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSet()
        self.saveStationSet()
        FixInfo.saveStation.forEach{ [weak self] in
            self?.requestStationData(stationName: $0.stationName, lineCode: $0.lineCode, updnLine: $0.updnLine)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
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
    
    func saveStationSet(){
        guard let udValue = UserDefaults.standard.value(forKey: "saveStation") else {return}
        guard let data = udValue as? Data else {return}
        do {
            let list = try PropertyListDecoder().decode([SaveStationModel].self, from: data)
            FixInfo.saveStation = list
        }catch{
            print(error)
        }
    }
    
    func requestStationData(stationName : String, lineCode : String, updnLine: String){
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName)"
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "").responseDecodable(of: LiveStationModel.self){[weak self] response in
            guard let self = self else {return}
            switch response.result{
            case let .success(data):
                for real in data.realtimeArrivalList{
                    if real.subWayId == lineCode && real.upDown == updnLine{
                        self.realInfo.append(real)
                        self.mainTableView.mainTableView.reloadData()
                        break
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.realInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        cell.cellSet(margin: Int(self.navigationController?.systemMinimumLayoutMargins.leading ?? 0))
        cell.station.text = FixInfo.saveStation[indexPath.row].stationName
        cell.line.text = (FixInfo.saveStation[indexPath.row].line.replacingOccurrences(of: "0", with: ""))
        cell.arrivalTime.text = "\(self.realInfo[indexPath.row].useTime)분"
        cell.now.text = "\(self.realInfo[indexPath.row].previousStation)\(self.realInfo[indexPath.row].useCode)"
        cell.lineColor(line: FixInfo.saveStation[indexPath.row].line)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "환승 횟수 5번"
    }
}
