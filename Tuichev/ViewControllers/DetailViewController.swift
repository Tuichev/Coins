//
//  DetailViewController.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 05.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import UIKit

protocol DetailViewControllerProtocol: class {
    
}

class DetailViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var presenter: DetailPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    deinit {
        self.logoImageView.sd_cancelCurrentImageLoad()
    }
    
    func setupViews() {
        setupNavBar()
        setupEventInfo()
    }
    
    func setupNavBar() {
        self.title = StringValue.kDetailVCTitle
    }
    
}

extension DetailViewController {
    
    private func setupEventInfo() {
        setupProgressView()
        
        self.logoImageView.sd_setImage(with: presenter?.getImageUrl(), placeholderImage: nil, options: .highPriority, completed: nil)
        self.dateLabel.text = presenter?.getDate()
        self.coinsLabel.text = presenter?.getCoinsName()
        self.eventNameLabel.text = presenter?.event?.title
        self.descriptionLabel.text = presenter?.event?.description
    }
    
    private func setupProgressView() {
        
        guard let percent = presenter?.event?.percentage else { return }
        
        let valueForProgressView = Float(exactly: percent) ?? 0
        
        self.percentageLabel.text = "\(percent)%"
        self.progressView.progress = valueForProgressView * 0.01
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    
}
