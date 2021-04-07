//
//  ApodViewController.swift
//  WalEAstroApp
//
//  Created by Deepak Sahu on 07/04/21.
//

import UIKit

class ApodViewController: UIViewController {
    @IBOutlet weak var apodView: ApodView!
    let viewModel: ApodViewModel = ApodViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        if Network.isConnected(){
            apodView.hideError()
            if let request = ApodRequest.generateRequest("1vjePhiYQVn5Ub3hKwbEucCcKFfCTqbf61k51Fcd", stringUrl: APPURL.apod_image){
                viewModel.featchData(request)
            }
        }else{
            if !viewModel.featchOld(){
                apodView.showError()
            }else{
                apodView.hideError()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apodView.updateView(viewModel.viewData)
    }
}
extension ApodViewController: ApodDataDelegate{
    func reloadImage() {
        DispatchQueue.main.async {
            self.apodView.updateView(self.viewModel.viewData)
        }
    }
    func apiResponseApod(_ apod: Apod, error: APIError) {
        DispatchQueue.main.async {
            self.apodView.updateView(self.viewModel.viewData)
        }
    }
}
