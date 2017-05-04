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
    var authModel: AuthModel
    
    init(authenticate: AuthModel) {
        authModel = authenticate
    }
    
    func toggle(lightName: String, toggle: LightToggle, auth: AuthModel, completion: @escaping(String, LightToggle)->Void){
        Alamofire.request(NetworkRouter.toggleLight(lightName: lightName, lightToggle: toggle, authentication: auth)).responseObject { (response: DataResponse<LightsResultModel>) in
            guard response.result.isSuccess else{
                //an error has happened
                completion("Error", LightToggle.off)
                return
            }
            guard let lightName = response.value?.lightName, let toggle = response.value?.toggle else{
                completion("Error", LightToggle.off)
                return
            }
            //this is bad, fix it
            completion(lightName, LightToggle(rawValue: toggle)!)
        }
    }
}
