//
//  Network.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-03.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import Alamofire

public enum NetworkRouter: URLRequestConvertible {

    static let baseURLPath = "http://requestb.in/1mswxf71"
    
    static let timeoutInterval = 10*1000
    
    case toggleLight(lightName: String, lightToggle: LightToggle)
    case toggleBlinds(blindName: String, blindToggle: BlindsToggle)
    
    var method: HTTPMethod {
        switch self {
        case .toggleLight, .toggleBlinds:
            return .post
        }
    }

    var path: String {
        switch self {
            case .toggleLight:
                return "/toggleLight"
            case .toggleBlinds:
                return "/toggleBlinds"
        }
    }
    
    var shouldAuthenticate: Bool {
        switch self {
            case .toggleLight, .toggleBlinds:
                return true
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
            case let .toggleLight(lightName, toggle):
                return ["lightName": lightName, "toggle": toggle]
            case let .toggleBlinds(blindName, toggle):
                return ["blindName": blindName, "toggle": toggle]
            }
        }()
        
        let url = try NetworkRouter.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(NetworkRouter.timeoutInterval)
        
        if shouldAuthenticate, let token = KeychainService.getToken() {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
