//
//  LightsService.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-03.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class LightsService {
    
    class func toggle(lightName: String, toggle: LightToggle, auth: Bool, completion: @escaping(Result<LightsResultModel>) -> Void) {
        APIClient.default.request(router: NetworkRouter.toggleLight(lightName: lightName, lightToggle: toggle), completion: { (result: Result<LightsResultModel>) in
            completion(result)
        })
    }
}
