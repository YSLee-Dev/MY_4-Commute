//
//  ResultVC.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/08/30.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

class ResultVC : UITableViewController{
    let resultRow = PublishRelay<[row]>()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSet()
        self.bind()
    }
}

private extension ResultVC{
    func viewSet(){
        self.tableView.dataSource = nil
        self.tableView.register(ResultVCCell.self, forCellReuseIdentifier: "ResultVCCell")
        self.tableView.rowHeight = 70
    }
    
    func bind(){
        self.resultRow
            .bind(to: self.tableView.rx.items){ tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: "ResultVCCell", for: IndexPath(row: row, section: 0)) as? ResultVCCell else {return UITableViewCell()}
                cell.stationName.text = data.stationName
                cell.line.text = data.useLine
                cell.lineColor(line: data)
                
                return cell
            }
            .disposed(by: self.bag)
    }
}

extension ResultVC {
    /*
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     guard let row = self.row else {return}
     let title = row[indexPath.row].useLine == "2호선" ? "내선/외선" : "상하행선"
     
     let up = title == "내선/외선" ? "내선" : "상행"
     let down = title == "내선/외선" ? "외선" : "하행"
     
     let alert = UIAlertController(title: "\(title)을 선택해주세요.", message: nil, preferredStyle: .alert)
     alert.addAction(UIAlertAction(title: up, style: .destructive){ _ in
     FixInfo.saveStation.append(SavtationModel(type: .subway, stationName: row[indexPath.row].stationName, updnLine: up, line: row[indexPath.row].lineNumber.rawValue, lineCode: row[indexPath.row].lineCode))
     })
     alert.addAction(UIAlertAction(title: down, style: .default){ _ in
     FixInfo.saveStation.append(SaveStationModel(type: .subway, stationName: row[indexPath.row].stationName, updnLine: down, line: row[indexPath.row].lineNumber.rawValue, lineCode: row[indexPath.row].lineCode))
     })
     alert.addAction(UIAlertAction(title: "취소", style: .cancel))
     
     self.present(alert, animated: true)
     
     }
     */
}
