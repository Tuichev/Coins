//
//  Extensions.swift
//  Tuichev
//
//  Created by Vlad Tuichev on 05.01.2019.
//  Copyright © 2019 LoftSoft. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum Storyboard: String {
        case main = "Main"
    }
    
    convenience init(storyboard: Storyboard) {
        self.init(name: storyboard.rawValue, bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>(_ type: T.Type) -> T {
        let id = NSStringFromClass(T.self).components(separatedBy: ".").last!
        return self.instantiateViewController(withIdentifier: id) as! T
    }
}

extension UIViewController {
    
    class func instance(_ storyboard: UIStoryboard.Storyboard = .main) -> Self {
        let storyboard = UIStoryboard(storyboard: storyboard)
        let viewController = storyboard.instantiateViewController(self)
        return viewController
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func showErrAlert(msg: String) {
        self.showAlert(title: StringValue.kErrorAlertTitle, msg: msg)
    }
    
    func showAlert(title: String, msg: String, customActions: [UIAlertAction] = []) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            
            if customActions.isEmpty {
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            } else {
                for action in customActions {
                    alert.addAction(action)
                }
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    enum TagsGlobalViews: Int {
        case inBlockScreen = 64783268
        case blockScreen = 98567302
    }
    
    func blockScreenViewStart(flag: Bool) {
        
        DispatchQueue.main.async {
            
            let tag = TagsGlobalViews.blockScreen.rawValue
            
            guard let currentWindow = UIApplication.shared.keyWindow else {
                return
            }
            
            for v in currentWindow.subviews {
                if v.tag == tag {
                    guard let blv: BlockUILoadingView = v as? BlockUILoadingView else {
                        v.removeFromSuperview()
                        return
                    }
                    
                    blv.dismissView()
                    break
                }
            }
            
            if !flag { return }
            
            let blview = BlockUILoadingView.fromNib()
            blview.frame = currentWindow.frame
            blview.tag = tag
            currentWindow.addSubview(blview)
            
        }
    }
    
    
    func inBlockScreenViewStart(flag: Bool) {
        
        DispatchQueue.main.async {
            
            let tag = TagsGlobalViews.inBlockScreen.rawValue
            
            for v in self.view.subviews {
                if v.tag == tag {
                    v.removeFromSuperview()
                    break
                }
            }
            
            if !flag {
                return
            }
            
            let heightContainer: CGFloat = 80.0
            
            let container = UIView.init(frame: CGRect(x: 0, y: 0, width: heightContainer, height: heightContainer))
            container.tag = tag
            
            container.center = self.view.center
            container.viewCorner(10)
            container.backgroundColor = UIColor.clear
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: heightContainer/4, y: heightContainer/4, width: heightContainer/2, height: heightContainer/2))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = .whiteLarge
            loadingIndicator.color = UIColor.black
            let transform: CGAffineTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            loadingIndicator.transform = transform
            loadingIndicator.startAnimating()
            
            container.addSubview(loadingIndicator)
            
            self.view.addSubview(container)
        }
    }
}

extension UIView {
    
    func viewCorner(_ radius: CGFloat? = nil) {
        layer.cornerRadius = radius ?? self.frame.height / 2
        layer.masksToBounds = true
    }
    
    func viewBorder(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }   
}

extension UITableViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }
}
