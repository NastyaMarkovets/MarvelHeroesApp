//
//  MarvelTabBarController.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 2/28/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit
import FirebaseAuth

class MarvelTabBarController: UITabBarController {
  
    lazy var logOutButton: UIButton = {
      let logOutButton = UIButton()
      logOutButton.setTitle("Sign Out", for: .normal)
      logOutButton.setTitleColor(UIColor(red: 66.0/255.0, green: 143.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .normal)
      logOutButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14.0)
      logOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
      return logOutButton
    }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let logOutItem = UIBarButtonItem(customView: logOutButton)
    self.navigationItem.setRightBarButton(logOutItem, animated: true)
    tabBarSetting()
  }
  
  private func tabBarSetting() {
    let heroesViewController = HeroesViewController()
    heroesViewController.tabBarItem = UITabBarItem(title: "All heroes",
                                                   image: UIImage(named: "heroes")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal),
                                                   selectedImage: UIImage(named: "heroesActive")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
    
    let favoriteHeroViewController = FavoriteHeroViewController()
    favoriteHeroViewController.tabBarItem = UITabBarItem(title: "Favorite",
                                                         image: UIImage(named: "favorite")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal),
                                                         selectedImage: UIImage(named: "favoriteActive")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
    
    tabBar.unselectedItemTintColor = UIColor(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1.0)
    tabBar.tintColor = UIColor(red: 66.0/255.0, green: 143.0/255.0, blue: 222.0/255.0, alpha: 1.0)
    let tabBarList = [heroesViewController, favoriteHeroViewController]
    
    viewControllers = tabBarList
  }
  
  @objc func signOut() {
    do {
      let signUpViewController = SignUpViewController()
      try Auth.auth().signOut()
      present(signUpViewController, animated: true, completion: nil)
    } catch let error {
      print(error)
    }
  }
  
}
