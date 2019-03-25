//
//  SignUpViewController.swift
//  MarvelHeroesApp
//
//  Created by LocalUser on 25/03/2019.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
  let requestModel = RequestModel()
  
  private enum Dimensions {
    static let inset: CGFloat = 18
  }
  
  lazy var signUpStackView: UIStackView = {
    let signUpStackView = UIStackView()
    signUpStackView.spacing = 12
    signUpStackView.axis = .vertical
    return signUpStackView
  }()
  
  lazy var signUpLabel: UILabel = {
    let signUpLabel = UILabel()
    signUpLabel.text = "Create your personal account"
    signUpLabel.textAlignment = .center
    signUpLabel.numberOfLines = 2
    signUpLabel.font = UIFont(name: "HelveticaNeue-Light", size: 24.0)
    return signUpLabel
  }()
  
  lazy var emailLabel: UILabel = {
    let emailLabel = UILabel()
    emailLabel.text = "Email"
    emailLabel.textAlignment = .left
    emailLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
    return emailLabel
  }()
  
  lazy var passwordLabel: UILabel = {
    let passwordLabel = UILabel()
    passwordLabel.text = "Password"
    passwordLabel.textAlignment = .left
    passwordLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
    return passwordLabel
  }()
  
  lazy var emailTextField: UITextField = {
    let emailTextField = UITextField()
    emailTextField.font = UIFont(name: "HelveticaNeue-Regular", size: 14.0)
    emailTextField.placeholder = "Enter your email..."
    return emailTextField
  }()
  
  lazy var passwordTextField: UITextField = {
    let passwordTextField = UITextField()
    passwordTextField.font = UIFont(name: "HelveticaNeue-Regular", size: 14.0)
    passwordTextField.placeholder = "Enter your password..."
    return passwordTextField
  }()
  
  lazy var signUpButton: UIButton = {
    let signUpButton = UIButton()
    signUpButton.autoSetDimensions(to: CGSize(width: 70.0, height: 30.0))
    signUpButton.setTitle("Sign Up", for: .normal)
    signUpButton.backgroundColor = UIColor(red: 0 / 255.0, green: 160.0 / 255.0, blue: 0 / 255.0, alpha: 1)
    signUpButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14.0)
    signUpButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
    return signUpButton
  }()

  lazy var linkToSignInButton: UIButton = {
    let linkToSignInButton = UIButton()
    linkToSignInButton.autoSetDimensions(to: CGSize(width: 70.0, height: 30.0))
    linkToSignInButton.setTitle("Sign In", for: .normal)
    linkToSignInButton.setTitleColor(UIColor(red: 66.0/255.0, green: 143.0/255.0, blue: 222.0/255.0, alpha: 1.0), for: .normal)
    linkToSignInButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14.0)

    linkToSignInButton.addTarget(self, action: #selector(transitionToSignIn), for: .touchUpInside)
    return linkToSignInButton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addSubviews()
    setupConstraints()
  }
  
  private func addSubviews() {
    view.addSubview(signUpLabel)
    view.addSubview(signUpStackView)
    view.addSubview(linkToSignInButton)
  }
  
  private func setupConstraints() {
    
    signUpStackView.addArrangedSubview(emailLabel)
    signUpStackView.addArrangedSubview(emailTextField)
    signUpStackView.addArrangedSubview(passwordLabel)
    signUpStackView.addArrangedSubview(passwordTextField)
    signUpStackView.addArrangedSubview(signUpButton)
    
    signUpStackView.autoAlignAxis(toSuperviewAxis: .horizontal)
    signUpStackView.autoPinEdge(toSuperviewEdge: .left, withInset: Dimensions.inset)
    signUpStackView.autoPinEdge(toSuperviewEdge: .right, withInset: Dimensions.inset)
    
    signUpLabel.autoPinEdge(.bottom, to: .top, of: signUpStackView, withOffset: -Dimensions.inset * 2)
    signUpLabel.autoPinEdge(toSuperviewEdge: .left, withInset: Dimensions.inset)
    signUpLabel.autoPinEdge(toSuperviewEdge: .right, withInset: Dimensions.inset)
  
    linkToSignInButton.autoPinEdge(.top, to: .bottom, of: signUpStackView, withOffset: Dimensions.inset)
    linkToSignInButton.autoPinEdge(toSuperviewEdge: .right, withInset: Dimensions.inset)
  }
  
  @objc func transitionToSignIn() {
    let signInViewController = SignInViewController()
    present(signInViewController, animated: true, completion: nil)
  }
  
  @objc func createAccount() {
    if emailTextField.text != "" && passwordTextField.text != "" {
      guard let email = emailTextField.text, let password = passwordTextField.text else { return }
      requestModel.createUser(email: email, password: password, success: { (user) in
        print(user)
        let marvelTabBarController = MarvelTabBarController()
        let navigationController = UINavigationController(rootViewController: marvelTabBarController)
        self.present(navigationController, animated: true, completion: nil)
      }) { (error) in
        let errorAlert = UIAlertController(title: error, message: "Please, try again", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        errorAlert.addAction(defaultAction)
        self.present(errorAlert, animated: true, completion:  nil)
        print(error)
      }
    } else {
      let emptyTextFieldAlert = UIAlertController(title: nil, message: "Please enter your email or password", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      emptyTextFieldAlert.addAction(defaultAction)
      present(emptyTextFieldAlert, animated: true, completion:  nil)
    }
  }

}
