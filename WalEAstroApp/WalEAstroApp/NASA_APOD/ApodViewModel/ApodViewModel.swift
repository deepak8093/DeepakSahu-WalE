//
//  ApodViewModel.swift
//  WalEAstroApp
//
//  Created by Deepak Sahu on 07/04/21.
//

import Foundation
import UIKit

protocol ApodDataDelegate: ApiDelegate {
    func reloadImage()
}
protocol ApodProtocol: ApodDataDelegate where Self:ApodViewModel{
    func featchData(_ request: URLRequest)
    func featchOld() -> Bool
    func downloadImage(with url: URL) throws
    func saveImage(_ image: UIImage) throws
}

class ApodViewModel  {
    private let apiSocket = ApiSocket()
    var delegate: ApodDataDelegate!
    var model: ApodUserDefault = ApodUserDefault()
    var viewData: ApodViewData = ApodViewData()
    private lazy var json: Apod = Apod()
}

extension ApodViewModel: ApodProtocol{
    func reloadImage() {}
    
    func featchOld() -> Bool{
        if model.isImageExist(){
            let store = model.getImage()
            self.viewData.image = UIImage.init(contentsOfFile: store.image)
            self.viewData.description = store.description
            self.viewData.title = store.title
            self.delegate.reloadImage()
            if (store.date ?? "") == Date().string(format: "ddMMyyyy"){
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    func featchData(_ request: URLRequest) {
        if model.isImageExist(){
            let store = model.getImage()
            if (store.date ?? "") == Date().string(format: "ddMMyyyy"){
                if let image = UIImage.init(contentsOfFile: store.image){
                    self.viewData.image = image
                    self.viewData.description = store.description
                    self.viewData.title = store.title
                    self.delegate.reloadImage()
                    return
                }
               
            }
        }
        apiSocket.getApodFromRequest(request) { (data, error) in
            if let data = data, error == nil, self.delegate != nil{
                do{
                    let json_apod = try JSONDecoder().decode(Apod.self, from: data)
                    if let url = URL.init(string: json_apod.hdurl){
                        try self.downloadImage(with: url)
                        self.json = json_apod
                        self.viewData.description = json_apod.explanation
                        self.viewData.title = json_apod.title
                        self.delegate.apiResponseApod(json_apod, error: APIError.noError)
                    }
                }catch{
                    self.delegate.apiResponseApod(self.json, error: (error as? APIError) ?? APIError.unkonwn)
                    debugPrint(APIError.self)
                }
                
            }else{
                //Error
            }
        }
    }
    func saveImage(_ image: UIImage) throws {
        model.saveImage(image, json: json)
        if model.isImageExist(){
            //all set
            self.viewData.image = UIImage.init(contentsOfFile: model.getImage().image)
            self.delegate.reloadImage()
        }else{
            throw APIError.noImage
        }
    }
    func downloadImage(with url: URL) throws {
        apiSocket.getApodFromRequest(URLRequest.init(url: url)) { (data, error) in
            if let data = data, error == nil{
                if let image = UIImage.init(data: data){
                    try self.saveImage(image)
                }else{
                    throw APIError.noImage
                }
            }else{
                throw APIError.badURL
            }
        }
    }
}
