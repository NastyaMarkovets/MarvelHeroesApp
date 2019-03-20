//
//  ApiModel.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 3/2/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import Foundation

class ApiModel {
  
  fileprivate let timestamp = Int(Date().timeIntervalSince1970)
  fileprivate var hash = String()
  
  func gettingAuth() -> String {
    hash = "\(timestamp)\(PRIVATE_KEY)\(PUBLIC_KEY)".md5()
    return ["ts": timestamp, "apikey": PUBLIC_KEY, "hash": hash].queryString!
  }
  
}
