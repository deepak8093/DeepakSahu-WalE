//
//  Loader.swift
//  WalEAstroApp
//
//  Created by Deepak Sahu on 08/04/21.
//

import Foundation
import UIKit
class Loader{
    private init(){}
    private static var sharedLoader: Loader = {
        let sharedSLoader = Loader()
        return sharedSLoader
    }()
    
    class func shared() -> Loader {
        return sharedLoader
    }
    private var loadingView: UIView!
    private var loadingLabel: UILabel!
    private var loadingIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
    func showLoader(_ view: UIView, text: String){
        if loadingView == nil{
            DispatchQueue.main.async {
                
                self.loadingView =  UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 200, height: 200)))
                view.addSubview(self.loadingView)
                self.loadingView.alpha = 0.1
                self.loadingLabel = UILabel.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 200 - 66), size: CGSize.init(width: 200, height: 44)))
                self.loadingLabel.text = text
                self.loadingLabel.textAlignment = .center
                self.loadingView.addSubview(self.loadingLabel)
                self.loadingView.addSubview(self.loadingIndicator)
                self.loadingIndicator.center = self.loadingView.center
                self.loadingIndicator.startAnimating()
                self.loadingView.center = view.center
                self.loadingView.backgroundColor = UIColor.white
                self.loadingView.layer.cornerRadius = 5
                self.loadingView.layer.masksToBounds = true
                UIView.animate(withDuration: 0.2) {
                    self.loadingView.alpha = 1.0
                } completion: { (_) in}
            }
        }else{
            self.loadingLabel.text = text
        }
        
        
    }
    func stopLoader(){
        if self.loadingView != nil{
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2) {
                    self.loadingView.alpha = 0.0
                    
                } completion: { (_) in
                    self.loadingView.removeFromSuperview()
                }

                
            }
        }        
    }
}
