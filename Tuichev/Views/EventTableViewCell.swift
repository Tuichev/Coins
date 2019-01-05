//
//  CoinTableViewCell.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 04.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import UIKit
import SDWebImage

protocol EventTableViewCellProtocol {
    func display(title: String?)
    func display(date: String?)
    func display(percentage: Int?)
    func display(description: String?)
    func display(logo: String?)
    func display(coinName: String?)
}

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override func prepareForReuse() {
        
        coinNameLabel.text = nil
        dateLabel.text = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        progressLabel.text = nil
        progressView.progress = 0
        logoImageView.sd_cancelCurrentImageLoad()
        logoImageView.image = nil
    }
    
}

extension EventTableViewCell: EventTableViewCellProtocol {
    
    func display(title: String?) {
        self.titleLabel.text = title
    }
    
    func display(date: String?) {
        self.dateLabel.text = date
    }
    
    
    func display(description: String?) {
        self.descriptionLabel.text = description
    }
    
    
    func display(coinName: String?) {
        self.coinNameLabel.text = coinName
    }
    
    func display(logo: String?) {
        
        let url = URL(string: logo ?? "")
        
        self.logoImageView.sd_setImage(with: url, placeholderImage: nil, options: .highPriority, completed: nil)
    }
    
    func display(percentage: Int?) {
        
        guard let percent = percentage else { return }
        
        let valueForProgressView = Float(exactly: percent) ?? 0
        
        self.progressLabel.text = "\(percent)%"
        self.progressView.progress = valueForProgressView * 0.01
    }
}
