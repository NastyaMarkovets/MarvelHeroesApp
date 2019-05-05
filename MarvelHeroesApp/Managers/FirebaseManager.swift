//
//  FirebaseManager.swift
//  MarvelHeroesApp
//
//  Created by LocalUser on 29/03/2019.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import BrightFutures

class FirebaseManager: NSObject {
  let auth = Auth.auth()
  let database = Database.database().reference()
  var uid: String? {
    get {
      return auth.currentUser?.uid
    }
  }
  
  func createUser(email: String, password: String) -> Future<String, NetworkRequestError> {
    return Future { complete in
      auth.createUser(withEmail: email, password: password) { (user, error) in
        if error == nil {
          complete(.success("You have successfully signed up"))
        } else {
          guard let acceptedError = error else { return }
          complete(.failure(NetworkRequestError.customError(value: acceptedError)))
        }
      }
    }
  }
  
  func signInAccount(email: String, password: String) -> Future<String, NetworkRequestError> {
    return Future { complete in
      auth.signIn(withEmail: email, password: password) { (user, error) in
        if error == nil {
          complete(.success("You have successfully signed in"))
        } else {
          guard let acceptedError = error else { return }
          complete(.failure(NetworkRequestError.customError(value: acceptedError)))
        }
      }
    }
  }
  
  func setHero(heroId: Int) -> Future<String, NetworkRequestError> {
    return Future { complete in
      guard let userId = uid else { return }
      database.child("users").child("\(userId)").setValue(["heroId" : heroId])
      complete(.success("Set ID hero to database"))
    }
  }
  
  func fetchHero() -> Future<Int, NetworkRequestError> {
    return Future { complete in
      guard let userId = uid else { return }
      database.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
        let value = snapshot.value as? NSDictionary
        let heroId = value?["heroId"] as? Int ?? 0
        complete(.success(heroId))
      }) { (error) in
        print(error.localizedDescription)
        complete(.failure(NetworkRequestError.networkRequestFailed))
      }
    }
  }
  
}
