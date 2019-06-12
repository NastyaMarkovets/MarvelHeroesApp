//
//  HeroesViewController.swift
//  MarvelHeroesApp
//
//  Created by Anastasia Markovets on 2/28/19.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit
import PureLayout
import Kingfisher
import FirebaseAuth
import FirebaseDatabase
import BrightFutures

class HeroesViewController: UIViewController {
  
  private let cellId = "cellId"
  private var currentPage = 0
  var heroes: [Hero] = []
  let heroComicsViewController = HeroComicsViewController()
  private var idFavoriteHero = 0 {
    didSet {
      self.heroesTableView.reloadData()
    }
  }
  
  private enum Dimensions {
    static let inset: CGFloat = 0
    static let heightCell: CGFloat = 130
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
    FactoryManager.shared.firebaseManager.fetchHero().onSuccess { [weak self] heroId in
      guard let self = self else {
        return
      }
      self.idFavoriteHero = heroId
    }
  }
  
  private func addSubviews() {
    view.addSubview(heroesTableView)
    view.addSubview(indicator)
  }
  
  private func setupConstraints() {
    heroesTableView.autoPinEdge(toSuperviewEdge: .top, withInset: UIApplication.shared.statusBarFrame.height)
    heroesTableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: tabBarController?.tabBar.frame.height ?? Dimensions.inset)
    heroesTableView.autoPinEdge(toSuperviewEdge: .right, withInset: Dimensions.inset)
    heroesTableView.autoPinEdge(toSuperviewEdge: .left, withInset: Dimensions.inset)
  }
  
  private func loadCharacters() {
    getAllCharacters().onSuccess { [weak self] success in
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
    }.onFailure { error in
      self.indicator.stopAnimating()
      print(error.localizedDescription)
    }
  }
  
  func getAllCharacters() -> Future<[Hero], NetworkRequestError> {
    return FactoryManager.shared.marvelAPIManager.getCharacters(page: currentPage)
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
    cell.configureCell(hero: heroes[indexPath.row], favoriteId: idFavoriteHero)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Dimensions.heightCell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if ((indexPath.row + 1) % 7 == 0) && (indexPath.row + 1 == heroes.count) {
      currentPage += 1
      loadCharacters()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt didSelectRowAtIndexPath: IndexPath) {
    heroComicsViewController.heroId = heroes[didSelectRowAtIndexPath.row].heroId
    navigationController?.pushViewController(heroComicsViewController, animated: true)
  }
}

// MARK: - FavoriteHeroDelegate methods
extension HeroesViewController: FavoriteHeroDelegate {
  func setFavoriteHero(nameHero: String, heroId: Int) {
    idFavoriteHero = heroId
    let alertFavorite = FactoryManager.shared.alertManager.addAlert(message: "Now, \(nameHero) is your favorite character")
    self.present(alertFavorite, animated: true, completion: nil)
  }
}

