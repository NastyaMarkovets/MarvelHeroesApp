//
//  HeroesViewController.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 2/28/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit
import PureLayout
import RealmSwift
import Kingfisher

class HeroesViewController: UIViewController {
  
  private let cellId = "cellId"
  private var currentPage = 0
  var heroes: [Hero] = []
  let realm = try! Realm()
  let requestModel = RequestModel()
  
  private var favoriteHero = "" {
    didSet {
      heroesTableView.reloadData()
    }
  }
  
  lazy var indicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    indicator.backgroundColor = .white
    indicator.hidesWhenStopped = true
    indicator.style = .gray
    return indicator
  }()
  
  lazy var heroesTableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(HeroTableViewCell.self, forCellReuseIdentifier: cellId)
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    indicator.startAnimating()
    
    addSubviews()
    setupConstraints()
    loadCharacters()
    
    if realm.objects(Hero.self).count != 0 {
      favoriteHero = realm.objects(Hero.self)[0].nameHero
    }
  }
  
  private func addSubviews() {
    view.addSubview(heroesTableView)
    view.addSubview(indicator)
  }
  
  private func setupConstraints() {
    heroesTableView.autoPinEdge(toSuperviewEdge: .top, withInset: UIApplication.shared.statusBarFrame.height)
    heroesTableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: tabBarController?.tabBar.frame.height ?? 0)
    heroesTableView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
    heroesTableView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
  }
  
  private func loadCharacters() {
    requestModel.getCharacters(page: currentPage, success: { [weak self] (success) in
      guard let self = self else {
        return
      }
      self.heroes += success
      self.heroesTableView.reloadData()
      UIView.animate(withDuration: 0.5, animations: {
        self.indicator.alpha = 0
      }, completion: { (bool) in
        self.indicator.stopAnimating()
      })
    }) { (failure) in
      self.indicator.stopAnimating()
    }
  }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension HeroesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return heroes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HeroTableViewCell else {
      return UITableViewCell()
    }
    cell.delegate = self
    cell.configureCell(hero: heroes[indexPath.row], favoriteName: favoriteHero)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 130
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if ((indexPath.row + 1) % 7 == 0) && (indexPath.row + 1 == heroes.count) {
      currentPage += 1
      loadCharacters()
    }
  }
}

// MARK: - FavoriteHeroDelegate methods
extension HeroesViewController: FavoriteHeroDelegate {
  func setFavoriteHero(_ nameHero: String) {
    favoriteHero = nameHero
    let alert = UIAlertController(title: "Now, \(nameHero) is your favorite character", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
}
