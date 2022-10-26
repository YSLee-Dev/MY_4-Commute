//
//  MainTableView.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/08/30.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa

class MainTableView : UITableView {
    
    let stationData = PublishRelay<[RealtimeStationArrival]>()
    let bag = DisposeBag()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.viewSet()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSet(){
        self.register(MainTableViewCell.self, forCellReuseIdentifier: "MainCell")
        self.dataSource = nil
        self.rowHeight = 100
        self.separatorStyle = .none
    }
    
    private func bind(){
        self.stationData
            .bind(to: self.rx.items){ tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: "MainCell", for: IndexPath(row: row, section: 0)) as? MainTableViewCell else {return UITableViewCell()}
                
                cell.cellSet(margin: Double(data.size ?? "") ?? 0)
                cell.station.text = "\(data.stationName) | \(data.upDown)"
                cell.line.text = data.useLine

                cell.arrivalTime.text = "\(data.useTime)"
                cell.now.text = "\(data.useFast)\(data.previousStation)\(data.useCode)"
                cell.lineColor(line: data.lineNumber!)
                return cell
            }
            .disposed(by: self.bag)
    }
}
