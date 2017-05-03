//
//  Network.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-03.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import Alamofire

public enum NetworkRouter: URLRequestConvertible{

    static let baseURLPath = "http://requestb.in/1mswxf71"
    
    case toggleLight(String, LightToggle)
    case toggleBlinds(String, BlindsToggle)
    
    var method: HTTPMethod{
        switch self {
        case .toggleLight:
            return .post
        case .toggleBlinds:
            return .post
        }
    }
    
    var path: String{
        switch self {
            case .toggleLight:
                return "/toggleLight"
            case .toggleBlinds:
                return "/toggleBlinds"
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
        request.timeoutInterval = TimeInterval(10*1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

public enum BlindsToggle: String{
    case open, close
}

public enum LightToggle: String {
    case on, off
}


