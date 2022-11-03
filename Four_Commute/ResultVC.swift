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
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSet()
    }
    
    func bind(viewModel : ResultViewModel){
        viewModel.resultRow
            .bind(to: self.tableView.rx.items){ tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: "ResultVCCell", for: IndexPath(row: row, section: 0)) as? ResultVCCell else {return UITableViewCell()}
                cell.stationName.text = data.stationName
                cell.line.text = data.useLine
                cell.lineColor(line: data)
                
                return cell
            }
            .disposed(by: self.bag)
        
        self.tableView.rx.modelSelected(row.self)
            .bind(to: viewModel.clickRow)
            .disposed(by: self.bag)
    }
}

private extension ResultVC{
    func viewSet(){
        self.tableView.dataSource = nil
        self.tableView.register(ResultVCCell.self, forCellReuseIdentifier: "ResultVCCell")
        self.tableView.rowHeight = 70
    }
}
