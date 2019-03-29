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

class FirebaseManager: NSObject {
  let auth = Auth.auth()
  let database = Database.database().reference()
  var uid: String? {
    get {
      return auth.currentUser?.uid
    }
  }
  
  func createUser(email: String, password: String, success: @escaping (String) -> (), failure: @escaping (String) -> Void) {
    auth.createUser(withEmail: email, password: password) { (user, error) in
      if error == nil {
        success("You have successfully signed up")
      } else {
        guard let acceptedError = error?.localizedDescription else { return }
        failure("Sorry, \(String(describing: acceptedError))")
        
      }
    }
  }
  
  func signInAccount(email: String, password: String, success: @escaping (String) -> (), failure: @escaping (String) -> Void) {
    auth.signIn(withEmail: email, password: password) { (user, error) in
      if error == nil {
        success("You have successfully signed in")
      } else {
        guard let acceptedError = error?.localizedDescription else { return }
        failure("Sorry, \(String(describing: acceptedError))")
      }
    }
  }
  
  func setHero(heroId: Int, success: @escaping (String) -> ()) {
    guard let userId = uid else { return }
    database.child("users").child("\(userId)").setValue(["heroId" : heroId])
    success("Set ID hero to database")
  }
  
  func fetchHero(success: @escaping (Int) -> ()) {
    guard let userId = uid else { return }
    database.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
      let value = snapshot.value as? NSDictionary
      let heroId = value?["heroId"] as? Int ?? 0
      success(heroId)
    }) { (error) in
      print(error.localizedDescription)
    }
  }
}
