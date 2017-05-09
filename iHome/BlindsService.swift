//
//  BlindsService.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-08.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class BlindsService {
    
    //default authentication to be false
    var shouldAuthenticate: Bool
    
    init(authenticate: Bool) {
        shouldAuthenticate = authenticate
    }
    
    func toggle(blindName: String, toggle: BlindsToggle, auth: Bool, completion: @escaping(Result<LightsResultModel>)->Void){
        Alamofire.request(NetworkRouter.toggleBlinds(blindName: blindName, blindToggle: toggle)).validate(statusCode: 200..<300).responseObject { (response: DataResponse<LightsResultModel>) in
            completion(response.result)
        }
    }
}
