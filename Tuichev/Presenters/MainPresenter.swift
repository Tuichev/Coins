//
//  MainPresenter.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 04.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import Foundation

protocol MainPresenterProtocol {
    init(view: MainViewControllerProtocol)
    func getCellCount() -> Int
    func configurateCell(_ cell: EventTableViewCellProtocol, index: Int)
    func cellSelected(index: Int)
}

class MainPresenter: BasePresenter, MainPresenterProtocol {
    
    weak var view: MainViewControllerProtocol?
    
    var events: [Event] = []
    
    required init(view: MainViewControllerProtocol) {
        super.init()
        self.view = view
        
       AppManager.shared.checkToken() { [weak self] in
           self?.getEvents()
        }
    }
    
    func configurateCell(_ cell: EventTableViewCellProtocol, index: Int) {
        
        let item = self.events[index]
        let startDate = DateFormat.shared.forrmatedStringDate(str: item.date ?? "")
        let nameOfFirstCoin = item.coins?.first?.id ?? ""
   
        cell.display(title: item.title)
        cell.display(percentage: item.percentage)
        cell.display(description: item.description)
        cell.display(logo: getImageUrl(nameOfFirstCoin))
        cell.display(coinName: getCoinsName(item.coins))
        cell.display(date: startDate)
    }
    
    func getCellCount() -> Int {
        return events.count
    }
    
    func cellSelected(index: Int) {        
        self.view?.showDetailVC(self.events[index])
    }
    
    func getEvents() {
        
        self.view?.blockScreenViewStart(flag: true)
        
        RestClient.shared.getEvents(resp: { [weak self] resp, error in
            
            self?.view?.blockScreenViewStart(flag: false)
            
            if let err = error {
                self?.view?.showErrAlert(msg: err.localizedDescription)
            }
            
            if let arr = resp as? [Event] {
                self?.events = arr
                self?.view?.reloadTableView()
            }
            
        })
    }
    
}
