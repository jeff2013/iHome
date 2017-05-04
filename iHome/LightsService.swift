//
//  LightsService.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-03.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import Foundation
import Alamofire

class LightsService {
    
    func toggle(lightName: String, toggle: LightToggle, completion: @escaping(String, LightToggle)->Void){
        Alamofire.request(NetworkRouter.toggleLight(lightName: lightName, lightToggle: toggle)).responseJSON { response in
            guard response.result.isSuccess else{
                //an error has happened
                completion("Error", LightToggle.off)
                return
            }
            guard let responseJSON = response.result.value as? [String: Any],
                let results = responseJSON["results"] as? [String: Any],
                let lightName = results["lightName"] as? String,
                let toggleString = results["toggle"] as? String,
                let toggle = LightToggle(rawValue: toggleString) else {
                    //invalid data returned
                    completion("Error", LightToggle.off)
                    return
            }
            completion(lightName, toggle)
        }
    }
}
