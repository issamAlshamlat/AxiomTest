//
//  NetworkHelper.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 23/06/2023.
//

import Foundation
import Alamofire

class NetworkHelper {

    static let shared = NetworkHelper()
    
    private static func request<T: Decodable>(url: URLConvertible, method: HTTPMethod, parameters: Parameters?, completion: @escaping (Swift.Result<T, Error>) -> Void) {

        LoaderManager.shared.showLoader()
        
        Alamofire.request(url, method: method, parameters: parameters).validate().responseJSON { response in
            LoaderManager.shared.hideLoader()
            
            switch response.result {
            case .success(let value):
                if let jsonData = try? JSONSerialization.data(withJSONObject: value), let parsedData = parseJSON(jsonData, type: T.self) {
                    completion(.success(parsedData))
                } else {
                    let error = NSError(domain: "JSONParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func parseJSON<T: Decodable>(_ data: Data, type: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let parsedData = try decoder.decode(type, from: data)
            return parsedData
        } catch {
            print("JSON parsing error: \(error)")
            return nil
        }
    }
    
    func getRequest<T: Decodable>(url: URL ,parameters: Parameters , completion: @escaping (Swift.Result<T, Error>) -> Void) {
        NetworkHelper.request(url: url, method: .get, parameters: parameters, completion: completion)
    }
    
//    func postRequest<T: Decodable>(url: URL, parameters: [String: Any]?, isReload: Bool, completion: @escaping (Swift.Result<T, Error>) -> Void) {
//        NetworkHelper.request(url: url, method: .post, parameters: parameters, isReload: isReload, completion: completion)
//    }
}
