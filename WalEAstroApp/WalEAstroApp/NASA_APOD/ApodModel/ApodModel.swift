//
//  ApodModel.swift
//  WalEAstroApp
//
//  Created by Deepak Sahu on 07/04/21.
//

import Foundation
import UIKit

struct Apod: Decodable {
    var date: String!
    var explanation: String!
    var hdurl: String!
    var media_type: String!
    var title: String!
    var url: String!
}
struct StoreImage: Codable {
    internal init(image: String? = nil, date: String? = nil, title: String? = nil, description: String? = nil) {
        self.image = image
        self.date = date
        self.title = title
        self.description = description
    }
    var image: String!
    var date: String!
    var title: String!
    var description: String!
}
struct ApodViewData{
    var image: UIImage!
    var title: String!
    var description: String!
}
class ApodUserDefault{
    func isImageExist() -> Bool{
        if let _ = UserDefaults.standard.value(forKey: "wal-e-image"){
            return true
        }else{
            return false
        }
    }
    func saveImage(_ newImage: UIImage, json: Apod){
        if isImageExist(){
            UserDefaults.standard.removeObject(forKey: "wal-e-image")
        }
        let date = Date().string(format: "ddMMyyyy")//To test Acceptance Criteria 3: Change date here manually 
        storeLocal(newImage)
        let store = StoreImage.init(image: "", date: date, title: json.title, description: json.explanation)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(store), forKey: "wal-e-image")
        UserDefaults.standard.synchronize()
    }
    func getImage() -> StoreImage{
        if let data = UserDefaults.standard.value(forKey: "wal-e-image") as? Data {
            var imageData = try! PropertyListDecoder().decode(StoreImage.self, from: data)
            let url = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + "apod_image.jpg"
            imageData.image = url
            return imageData
        } else {
            return StoreImage()
        }
    }
    
    private func storeLocal(_ image: UIImage){
        let fileName = "apod_image.jpg"
        let fileURL = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality:  1.0){
            do {
                if FileManager.default.fileExists(atPath: fileURL){
                    try FileManager.default.removeItem(atPath: fileURL)
                }
                FileManager.default.createFile(atPath: fileURL, contents: data, attributes: nil)
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
}
