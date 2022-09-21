//
//  DetailVC.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/09/08.
//

import UIKit

class DetailVC : UIViewController {
    
    lazy var line = UILabel().then{
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 30
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 17)
        
        $0.text = FixInfo.saveStation[self.row].useLine
        $0.backgroundColor = UIColor(named: FixInfo.saveStation[self.row].line)
    }
    
    lazy var station = UILabel().then{
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 25)
        
        $0.text = FixInfo.saveStation[self.row].stationName.contains("역") ? FixInfo.saveStation[self.row].stationName : "\(FixInfo.saveStation[self.row].stationName)역"
    }
    
    var realInfo : RealtimeStationArrival
    var row : Int
    
    init(info : RealtimeStationArrival, index : IndexPath){
        self.realInfo = info
        self.row = index.row
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSet()
    }
}

private extension DetailVC{
    func viewSet(){
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        
        // 오토레이아웃
        self.view.addSubview(self.line)
        self.line.snp.makeConstraints{
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).inset(Int(self.navigationController?.systemMinimumLayoutMargins.leading ?? 0))
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.size.equalTo(60)
        }
        
        self.view.addSubview(self.station)
        self.station.snp.makeConstraints{
            $0.centerY.equalTo(self.line)
            $0.leading.equalTo(self.line.snp.trailing).offset(10)
        }
    }
    
}
