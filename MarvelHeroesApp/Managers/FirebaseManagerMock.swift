//
//  FirebaseManagerMock.swift
//  MarvelHeroesApp
//
//  Created by LocalUser on 5/24/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import Foundation
import BrightFutures

class FirebaseManagerMock: FirebaseManagerProtocol {
    
    func createUser(email: String, password: String) -> Future<String, NetworkRequestError> {
        return Future { complete in
            var result: Result<String, NetworkRequestError>?
            if let registerResult = result {
                switch registerResult {
                case .failure(_):
                    complete(.failure(NetworkRequestError.networkRequestFailed))
                case .success(_):
                    complete(.success("You have successfully signed up"))
                }
            }
        }
    }
    
    func signInAccount(email: String, password: String) -> Future<String, NetworkRequestError> {
        return Future { complete in
            var result: Result<String, NetworkRequestError>?
            if let signInResult = result {
                switch signInResult {
                case .failure(_):
                    complete(.failure(NetworkRequestError.networkRequestFailed))
                case .success(_):
                    complete(.success("You have successfully signed up"))
                }
            }
        }
    }
    
    func setHero(heroId: Int) -> Future<String, NetworkRequestError> {
        return Future { complete in
            var result: Result<String, NetworkRequestError>?
            if let heroResult = result {
                switch heroResult {
                case .failure(_):
                    complete(.failure(NetworkRequestError.networkRequestFailed))
                case .success(_):
                    complete(.success("Set ID hero to database"))
                }
            }
        }
    }
    
    func fetchHero() -> Future<Int, NetworkRequestError> {
        return Future { complete in
            var result: Result<String, NetworkRequestError>?
            if let heroResult = result {
                switch heroResult {
                case .failure(_):
                    complete(.failure(NetworkRequestError.networkRequestFailed))
                case .success(_):
                    guard let heroId = heroResult.result.value as? Int else { return complete(.success(0)) }
                    complete(.success(heroId))
                }
            }
        }
    }
    
}
