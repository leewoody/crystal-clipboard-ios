//
//  APIProvider.swift
//  CrystalClipboard
//
//  Created by Justin Mazzocchi on 9/9/17.
//  Copyright © 2017 Justin Mazzocchi. All rights reserved.
//

import Moya
import Alamofire

class APIProvider: MoyaProvider<CrystalClipboardAPI> {
    
    // MARK: Internal MoyaProvider overridden initializers
    
    override init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping RequestClosure = APIProvider.defaultRequestMapping,
         stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
         callbackQueue: DispatchQueue? = nil,
         manager: Manager? = nil,
         plugins: [PluginType] = [],
         trackInflights: Bool = false) {
        
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue ?? APIProvider.responseProcessingQueue,
                   manager: manager ?? PinningManager(),
                   plugins: plugins,
                   trackInflights: trackInflights)
    }
    
    convenience init(token: String) {
        self.init(plugins: [AccessTokenPlugin(tokenClosure: token)])
    }
}

private extension APIProvider {
    
    // MARK: Private constants
    
    private static let responseProcessingQueue = DispatchQueue(label: "com.jzzocc.crystal-clipboard.response-processing-queue",  attributes: .concurrent)
}
