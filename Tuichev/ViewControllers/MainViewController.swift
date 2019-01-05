//
//  ViewController.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 04.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import UIKit

protocol MainViewControllerProtocol: class {
    func showErrAlert(msg: String)
    func blockScreenViewStart(flag: Bool)
    func reloadTableView()
    func showDetailVC(_ event: Event?)
}

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: MainPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(view: self)
        setupViews()
    }
    
    func setupViews() {
        setupTableView()
        setupNavBar()
    }
    
    func setupNavBar() {
        self.title = StringValue.kMainVCTitle
    }
    
    func setupTableView() {
         self.tableView.register(UINib (nibName: EventTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: EventTableViewCell.identifier)
    }

}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getCellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as! EventTableViewCell
        presenter.configurateCell(cell, index: indexPath.item)
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.cellSelected(index: indexPath.item)
    }
    
}

extension MainViewController: MainViewControllerProtocol {
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showDetailVC(_ event: Event?) {
        DispatchQueue.main.async {
            
            let detailVC = DetailViewController.instance(.main)
            let detailPresenter = DetailPresenter(view: detailVC)
            
            detailPresenter.event = event
            detailVC.presenter = detailPresenter
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}

