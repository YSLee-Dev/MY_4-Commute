//
//  ResultVCCell.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/08/30.
//

import UIKit

import Then
import SnapKit

class ResultVCCell : UITableViewCell{
    
    var stationName = UILabel().then{
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    var line = UILabel().then{
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 22.5
        $0.backgroundColor = UIColor(hue: 0.9333, saturation: 0.89, brightness: 0.9, alpha: 1.0)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 13)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "ResultVCCell")
        self.cellSet()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func lineColor(line : row){
        self.line.backgroundColor = UIColor(named: line.lineNumber.rawValue)
    }
    
    private func cellSet(){
        self.contentView.addSubview(self.stationName)
        self.contentView.addSubview(self.line)
        
        self.stationName.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
        
        self.line.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(45)
        }
    }
}
