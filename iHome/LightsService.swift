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

class LightsService {
    
    //default authentication to be false
    var shouldAuthenticate: Bool
    
    init(authenticate: Bool) {
        shouldAuthenticate = authenticate
    }
    
    func toggle(lightName: String, toggle: LightToggle, auth: Bool, completion: @escaping(Result<LightsResultModel>)->Void){
        Alamofire.request(NetworkRouter.toggleLight(lightName: lightName, lightToggle: toggle)).validate(statusCode: 200..<300).responseObject { (response: DataResponse<LightsResultModel>) in
            completion(response.result)
        } 
    }
}
