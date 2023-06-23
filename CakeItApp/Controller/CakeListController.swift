//
//  CakeListController.swift
//  CakeItApp
//
//  Created by Karekar, Mangesh on 23/06/2023.
//

import Foundation


class CakeListController {
    
    private let network = Network()
    private let cakeListUrlString = "https://gist.githubusercontent.com/hart88/79a65d27f52cbb74db7df1d200c4212b/raw/ebf57198c7490e42581508f4f40da88b16d784ba/cakeList"
    
    func getCakeList( onSuccess: @escaping ([Cake])-> Void,
                      onFailure: @escaping (RequestError) -> Void) {
        
        network.performURLRequest(urlString: cakeListUrlString, modelType: [Cake].self) { result in
            switch result {
            case .success(let cakes):
                onSuccess(cakes)
            case .failure(let error):
                onFailure(error)
            }
        }
    }
    
}
