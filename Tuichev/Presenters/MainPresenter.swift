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
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewControllerProtocol?
    
    var events: [Event] = []
    
    required init(view: MainViewControllerProtocol) {
        self.view = view
        
        getEvents()
    }
    
    func configurateCell(_ cell: EventTableViewCellProtocol, index: Int) {
        
        let item = self.events[index]
        let startDate = DateFormat.shared.forrmatedStringDate(str: item.date ?? "")

        //bad way for logo, but i didn't find another url except 'proof'
        let nameOfFirstCoin = item.coins?.first?.id ?? ""
        let logoUrl = "https://d235dzzkn2ryki.cloudfront.net/\(nameOfFirstCoin)_normal.png"
        
        cell.display(title: item.title)
        cell.display(percentage: item.percentage)
        cell.display(description: item.description)
        cell.display(logo: logoUrl)
        cell.display(coinName: getCoinsName(item.coins))
        cell.display(date: startDate)
    }
    
    func getCellCount() -> Int {
        return events.count
    }
    
    fileprivate func getCoinsName(_ coins: [Coin]?) -> String {
        
        var labelText: [String] = []
        coins?.forEach( { labelText.append($0.name ?? "") } )
      
        return labelText.joined(separator:",")
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
