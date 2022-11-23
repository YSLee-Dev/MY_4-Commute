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
    let bag = DisposeBag()
    
    lazy var refresh = UIRefreshControl().then{
        $0.backgroundColor = .white
        $0.attributedTitle = NSAttributedString("당겨서 새로고침")
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.viewSet()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSet(){
        self.register(MainTableViewCell.self, forCellReuseIdentifier: "MainCell")
        self.dataSource = nil
        self.rowHeight = 100
        self.separatorStyle = .none
        self.refreshControl = self.refresh
    }
    
    func bind(viewModel : MainTableViewModel){
        viewModel.stationData
            .bind(to: self.rx.items){ tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: "MainCell", for: IndexPath(row: row, section: 0)) as? MainTableViewCell else {return UITableViewCell()}
                
                cell.cellSet()
                cell.station.text = "\(data.stationName) | \(data.upDown)"
                cell.line.text = data.useLine
                
                cell.arrivalTime.text = "\(data.useTime)"
                cell.now.text = "\(data.useFast)\(data.cutString(cutString: data.previousStation)) \(data.useCode)"
                cell.lineColor(line: data.lineNumber!)
                
                self.refreshControl?.endRefreshing()
                
                return cell
            }
            .disposed(by: self.bag)
        
        self.refreshControl?.rx.controlEvent(.valueChanged)
            .asSignal(onErrorJustReturn: ())
            .emit(to: viewModel.refreshOn)
            .disposed(by: self.bag)
        
        viewModel.editBtnClick
            .bind(to: self.rx.isEditing)
            .disposed(by: self.bag)
        
        self.rx.itemDeleted
            .map{ index in
                var nowData = viewModel.stationData.value
                nowData.remove(at: index.row)
                viewModel.stationData.accept(nowData)
                FixInfo.saveStation.remove(at: index.row)
                return Void()
            }
            .bind(to: viewModel.refreshOn)
            .disposed(by: self.bag)
        
        self.rx.itemSelected
            .bind(to: viewModel.clickCell)
            .disposed(by: self.bag)
    }
}
