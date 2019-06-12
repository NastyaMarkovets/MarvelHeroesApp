//
//  SignUpViewController.swift
//  MarvelHeroesApp
//
//  Created by LocalUser on 25/03/2019.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
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
    signUpLabel.font = UIFont.fontHelveticaLight(size: 24.0)
    return signUpLabel
  }()
  
  lazy var emailLabel: UILabel = {
    let emailLabel = UILabel()
    emailLabel.text = "Email"
    emailLabel.textAlignment = .left
    emailLabel.font = UIFont.fontHelveticaLight(size: 12.0)
    return emailLabel
  }()
  
  lazy var passwordLabel: UILabel = {
    let passwordLabel = UILabel()
    passwordLabel.text = "Password"
    passwordLabel.textAlignment = .left
    passwordLabel.font = UIFont.fontHelveticaLight(size: 12.0)
    return passwordLabel
  }()
  
  lazy var emailTextField: UITextField = {
    let emailTextField = UITextField()
    emailTextField.font = UIFont.fontHelveticaRegular(size: 14.0)
    emailTextField.placeholder = "Enter your email..."
    emailTextField.delegate = self
    return emailTextField
  }()
  
  lazy var passwordTextField: UITextField = {
    let passwordTextField = UITextField()
    passwordTextField.font = UIFont.fontHelveticaRegular(size: 14.0)
    passwordTextField.placeholder = "Enter your password..."
    passwordTextField.delegate = self
    return passwordTextField
  }()
  
  lazy var signUpButton: UIButton = {
    let signUpButton = UIButton()
    signUpButton.autoSetDimensions(to: CGSize(width: 70.0, height: 30.0))
    signUpButton.setTitle("Sign Up", for: .normal)
    signUpButton.backgroundColor = UIColor.customGreen()
    signUpButton.titleLabel?.font = UIFont.fontHelveticaRegular(size: 14.0)
    signUpButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
    return signUpButton
  }()

  lazy var linkToSignInButton: UIButton = {
    let linkToSignInButton = UIButton()
    linkToSignInButton.autoSetDimensions(to: CGSize(width: 70.0, height: 30.0))
    linkToSignInButton.setTitle("Sign In", for: .normal)
    linkToSignInButton.setTitleColor(UIColor.customBlue(), for: .normal)
    linkToSignInButton.titleLabel?.font = UIFont.fontHelveticaRegular(size: 14.0)

    linkToSignInButton.addTarget(self, action: #selector(transitionToSignIn), for: .touchUpInside)
    return linkToSignInButton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addSubviews()
    setupConstraints()
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
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
  
  @objc func dismissKeyboard() {
    emailTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
  }
  
  @objc func transitionToSignIn() {
    let signInViewController = SignInViewController()
    present(signInViewController, animated: true, completion: nil)
  }
  
  @objc func createAccount() {
    guard let email = emailTextField.text, let password = passwordTextField.text else { return }
    if email.isEmpty && password.isEmpty {
      let emptyTexFieldAlert = FactoryManager.shared.alertManager.addAlert(message: "Please enter your email or password")
      present(emptyTexFieldAlert, animated: true, completion:  nil)
    } else {
      FactoryManager.shared.firebaseManager.createUser(email: email, password: password).onSuccess { user in
        print(user)
        let marvelTabBarController = MarvelTabBarController()
        let navigationController = UINavigationController(rootViewController: marvelTabBarController)
        self.present(navigationController, animated: true, completion: nil)
      }.onFailure { error in
        let errorAlert = FactoryManager.shared.alertManager.addAlert(message: error.localizedDescription)
        self.present(errorAlert, animated: true, completion:  nil)
        print(error)
      }
    }
  }

}

extension SignUpViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
