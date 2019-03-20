//
//  StringExtention.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 3/2/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
  func md5() -> String {
    let messageData = self.data(using: .utf8)
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    
    _ = digestData.withUnsafeMutableBytes { digestBytes in
      messageData?.withUnsafeBytes { messageBytes in
        CC_MD5(messageBytes, CC_LONG(messageData?.count ?? 0), digestBytes)
      }
    }
    return digestData.map { String(format: "%02hhx", $0) }.joined()
  }
}

extension Dictionary {
  var queryString: String {
    return reduce("") { "\($0)\($1.0)=\($1.1)&" }
  }
  
}
