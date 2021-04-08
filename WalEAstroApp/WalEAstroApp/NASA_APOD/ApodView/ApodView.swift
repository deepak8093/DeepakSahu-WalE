//
//  ApodView.swift
//  WalEAstroApp
//
//  Created by Deepak Sahu on 07/04/21.
//

import UIKit

class ApodView: UIView {
    private var container:UIView?
    var nibName:String = "ApodView"
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLable: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var description_i: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func draw(_ rect: CGRect) {
        title.layer.shadowColor = UIColor.black.cgColor
        title.layer.shadowRadius = 4.0
        title.layer.shadowOpacity = 0.6
        title.layer.shadowOffset = CGSize(width: 0, height: 4)
        title.layer.masksToBounds = false
        description_i.layer.shadowColor = UIColor.black.cgColor
        description_i.layer.shadowRadius = 4.0
        description_i.layer.shadowOpacity = 0.6
        description_i.layer.shadowOffset = CGSize(width: 0, height: 4)
        description_i.layer.masksToBounds = false
    }
    func updateView(_ data: ApodViewData){
        self.image.image = data.image
        self.image.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseIn) {
            self.image.transform = .identity
        } completion: { (_) in}        
        self.title.text = data.title
        self.description_i.text = data.description
    }
    func showError(){
        self.errorView.isHidden = false
        self.errorLable.text = "We are not connected to the internet, showing you the last image we have."
        
    }
    func hideError(){
        self.errorView.isHidden = true

    }
    
    override func awakeFromNib() {
        addXibToView()
        super.awakeFromNib()
    }
    
    private func addXibToView(){
        guard let view = loadViewFromNib() else {
            return
        }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if container == nil{
            self.addSubview(view)
        }
        container = view
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    
    
}
