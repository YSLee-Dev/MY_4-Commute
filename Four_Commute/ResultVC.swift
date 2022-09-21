//
//  ResultVC.swift
//  Four_Commute
//
//  Created by 이윤수 on 2022/08/30.
//

import UIKit

import Then
import SnapKit

class ResultVC : UITableViewController{
    
    var row : [row]? = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSet()
    }
}

private extension ResultVC{
    func viewSet(){
        self.tableView.register(ResultVCCell.self, forCellReuseIdentifier: "ResultVCCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension ResultVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.row?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultVCCell") as? ResultVCCell else {return UITableViewCell()}
        guard let row = self.row else {return UITableViewCell()}
        cell.stationName.text = row[indexPath.row].stationName
        cell.line.text = row[indexPath.row].useLine
        cell.lineColor(line: row[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = self.row else {return}
        let title = row[indexPath.row].useLine == "2호선" ? "내선/외선" : "상하행선"
        
        let up = title == "내선/외선" ? "내선" : "상행"
        let down = title == "내선/외선" ? "외선" : "하행"
        
        let alert = UIAlertController(title: "\(title)을 선택해주세요.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: up, style: .destructive){ _ in
            FixInfo.saveStation.append(SaveStationModel(type: .subway, stationName: row[indexPath.row].stationName, updnLine: up, line: row[indexPath.row].lineNumber.rawValue, lineCode: row[indexPath.row].lineCode))
        })
        alert.addAction(UIAlertAction(title: down, style: .default){ _ in
            FixInfo.saveStation.append(SaveStationModel(type: .subway, stationName: row[indexPath.row].stationName, updnLine: down, line: row[indexPath.row].lineNumber.rawValue, lineCode: row[indexPath.row].lineCode))
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
           
    }
}
