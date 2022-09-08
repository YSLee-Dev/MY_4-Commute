//
//  DetailVC.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/09/08.
//

import UIKit

class DetailVC : UIViewController {
    
    var realInfo : RealtimeStationArrival
    var stationName : String
    
    init(info : RealtimeStationArrival, name : String){
        self.realInfo = info
        self.stationName = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSet()
        print(self.realInfo)
    }
}

private extension DetailVC{
    func viewSet(){
        self.view.backgroundColor = .white
        self.navigationItem.title = self.stationName.contains("역") ? self.stationName : "\(self.stationName)역"
    }
}
