//
//  alertMessage.swift
//  MarvelHeroesApp
//
//  Created by LocalUser on 29/03/2019.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit

class AlertManager: NSObject {
  
  func addAlert(message: String) -> UIAlertController {
    let alertMessage = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertMessage.addAction(defaultAction)
    return alertMessage
  }
}
