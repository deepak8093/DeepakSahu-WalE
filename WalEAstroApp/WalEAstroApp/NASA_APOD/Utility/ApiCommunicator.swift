//
//  ApiCommunicator.swift
//  WalEAstroApp
//
//  Created by Deepak Sahu on 07/04/21.
//

import Foundation

enum APPURL: String{
    case apod_image = "https://api.nasa.gov/planetary/apod"
}

enum APIError: Error {
    case noInternet
    case badURL
    case authFail
    case noError
    case noAuth
    case noImage
    case unkonwn
}
struct ApodRequest {
    private var auth: String!
    private var duration: Int!
    private var Url: URL!
    static func generateRequest(_ token: String, stringUrl: APPURL) -> URLRequest?{
        if let url = URL.init(string: stringUrl.rawValue + "?" + "api_key=" + token){
            let request = URLRequest.init(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: TimeInterval.init(20))
            return request
        }else{
            return nil
        }
    }
}

protocol ApiDelegate {
    func apiResponseApod(_ apod: Apod, error: APIError)
}
extension ApiDelegate{
    func apiResponseApod(_ apod: Apod, error: APIError){}
}

class ApiSocket {
    var delegate: ApiDelegate!
}
extension ApiSocket: ApiDelegate{
    func getApodFromRequest(_ request: URLRequest,  completion: ((Data?, Error?) throws -> Void)?){
        let session = URLSession.shared
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            if let callback = completion {
                try? callback(data, nil)
            }
        }
        dataTask.resume()
    }
}
