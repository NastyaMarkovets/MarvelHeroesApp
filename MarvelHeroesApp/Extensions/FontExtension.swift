//
//  FontExtension.swift
//  MarvelHeroesApp
//
//  Created by LocalUser on 29/03/2019.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit

extension UIFont {
  class func fontHelveticaMedium(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
  }
  
  class func fontHelveticaRegular(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
  }
  
  class func fontHelveticaLight(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Light", size: size) ?? UIFont.systemFont(ofSize: size)
  }
}
