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
    
    class func toggle(blindName: String, toggle: BlindsToggle, completion: @escaping(Result<BlindsResultModel>) -> Void) {
        APIClient.default.request(router: NetworkRouter.toggleBlinds(blindName: blindName, blindToggle: toggle), completion: { (result: Result<BlindsResultModel>) in
            completion(result)
        })
    }
}
