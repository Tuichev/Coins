//
//  DetailPresenter.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 05.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import Foundation

protocol DetailPresenterProtocol {
    init(view: DetailViewControllerProtocol)
    func getImageUrl() -> URL?
    func getCoinsName() -> String
    func getDate() -> String
    var event: Event? { get }
}

class DetailPresenter: BasePresenter, DetailPresenterProtocol {
    
    weak var view: DetailViewControllerProtocol?
    
    var event: Event?
    
    required init(view: DetailViewControllerProtocol) {
        super.init()
        self.view = view
    }
    
    func getImageUrl() -> URL? {
        
        let firsCoinId = event?.coins?.first?.id ?? ""
        return URL(string: getImageUrl(firsCoinId))
    }
    
    func getCoinsName() -> String {
        return getCoinsName(event?.coins)
    }
    
    func getDate() -> String {       
        return DateFormat.shared.forrmatedStringDate(str: event?.date ?? "")
    }
    
}
