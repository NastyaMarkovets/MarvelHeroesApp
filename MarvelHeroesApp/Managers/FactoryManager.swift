//
//  FactoryManager.swift
//  MarvelHeroesApp
//
//  Created by LocalUser on 29/03/2019.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit

class FactoryManager: NSObject {
  static let shared = FactoryManager()
  
  let marvelAPIManager = MarvelAPIManager()
  let firebaseManager = FirebaseManager()
  let alertManager = AlertManager()
}
