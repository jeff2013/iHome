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
    
    case toggleLight(lightName: String, lightToggle: LightToggle, authentication: AuthModel)
    case toggleBlinds(blindName: String, blindToggle: BlindsToggle, authentication: AuthModel)
    
    var method: HTTPMethod{
        switch self {
        case .toggleLight, .toggleBlinds:
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
        var authModel:AuthModel?
        let parameters: [String: Any] = {
            switch self {
            case let .toggleLight(lightName, toggle, auth):
                authModel = auth
                return ["lightName": lightName, "toggle": toggle]
            case let .toggleBlinds(blindName, toggle, auth):
                authModel = auth
                return ["blindName": blindName, "toggle": toggle]
            }
        }()
        
        let url = try NetworkRouter.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10*1000)
        if (authModel?.authenticate)!, let token = authModel?.authenticationToken{
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
