//
//  MainTableViewCell.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/08/30.
//

import UIKit

import Then
import SnapKit

class MainTableViewCell : UITableViewCell{
    
    var mainBG = UIView().then{
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .secondarySystemBackground
    }
    
    var line = UILabel().then{
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 30
        $0.backgroundColor = UIColor(hue: 0.9333, saturation: 0.89, brightness: 0.9, alpha: 1.0)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    var station = UILabel().then{
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 15)
    }
    
    var now = UILabel().then{
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    var arrivalTime = UILabel().then{
        $0.textColor = .systemRed
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .right
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    func cellSet(margin : Int){
        self.contentView.addSubview(self.mainBG)
        self.mainBG.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(margin)
        }
        
        [self.line, self.station, self.now, self.arrivalTime].forEach{
            self.mainBG.addSubview($0)
        }
        self.line.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        self.station.snp.makeConstraints{
            $0.leading.equalTo(self.line.snp.trailing).offset(15)
            $0.bottom.equalTo(self.line.snp.centerY)
        }
        
        self.now.snp.makeConstraints{
            $0.leading.equalTo(self.line.snp.trailing).offset(15)
            $0.top.equalTo(self.line.snp.centerY)
        }
        
        self.arrivalTime.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(15)
            $0.leading.equalTo(self.station.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
    }
    
    func lineColor(line : String){
        self.line.backgroundColor = UIColor(named: line)
    }
}
