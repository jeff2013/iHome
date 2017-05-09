//
//  APIClient.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-09.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class APIClient {
    static let `default`: APIClient = APIClient()
    
    let sessionManager: SessionManager?
    
    init() {
        let configuration = URLSessionConfiguration.default
        let defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.httpAdditionalHeaders = defaultHeaders
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func request<T: Mappable>(router: NetworkRouter, completion: @escaping(Result<T>) -> Void) {
        sessionManager?.request(router).validate().responseJSON { response in
            switch response.result {
            case .success:
                let lightResult = Mapper<T>().map(JSONObject: response.result)
                completion(Result.success(lightResult!))
                break
            case .failure(let error):
                completion(Result.failure(error))
                break
            }
        }
    }
}
