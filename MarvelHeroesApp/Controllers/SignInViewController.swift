//
//  LogInViewController.swift
//  MarvelHeroesApp
//
//  Created by LocalUser on 25/03/2019.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
  
  private enum Dimensions {
    static let inset: CGFloat = 18
  }

  lazy var signInStackView: UIStackView = {
    let signInStackView = UIStackView()
    signInStackView.spacing = 12
    signInStackView.axis = .vertical
    return signInStackView
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
  
  lazy var signInButton: UIButton = {
    let signInButton = UIButton()
    signInButton.autoSetDimensions(to: CGSize(width: 70.0, height: 30.0))
    signInButton.setTitle("Sign In", for: .normal)
    signInButton.backgroundColor = UIColor.customGreen()
    signInButton.titleLabel?.font = UIFont.fontHelveticaRegular(size: 14.0)
    signInButton.addTarget(self, action: #selector(signInAccount), for: .touchUpInside)
    return signInButton
  }()
  
  lazy var linkToSignUpButton: UIButton = {
    let linkToSignUpButton = UIButton()
    linkToSignUpButton.autoSetDimensions(to: CGSize(width: 70.0, height: 30.0))
    linkToSignUpButton.setTitle("Sign Up", for: .normal)
    linkToSignUpButton.setTitleColor(UIColor.customBlue(), for: .normal)
    linkToSignUpButton.titleLabel?.font = UIFont.fontHelveticaRegular(size: 14.0)
    
    linkToSignUpButton.addTarget(self, action: #selector(transitionToSignUp), for: .touchUpInside)
    return linkToSignUpButton
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
    view.addSubview(signInStackView)
    view.addSubview(linkToSignUpButton)
  }
  
  private func setupConstraints() {
    
    signInStackView.addArrangedSubview(emailLabel)
    signInStackView.addArrangedSubview(emailTextField)
    signInStackView.addArrangedSubview(passwordLabel)
    signInStackView.addArrangedSubview(passwordTextField)
    signInStackView.addArrangedSubview(signInButton)
    
    signInStackView.autoAlignAxis(toSuperviewAxis: .horizontal)
    signInStackView.autoPinEdge(toSuperviewEdge: .left, withInset: Dimensions.inset)
    signInStackView.autoPinEdge(toSuperviewEdge: .right, withInset: Dimensions.inset)
    
    linkToSignUpButton.autoPinEdge(.top, to: .bottom, of: signInStackView, withOffset: Dimensions.inset)
    linkToSignUpButton.autoPinEdge(toSuperviewEdge: .right, withInset: Dimensions.inset)
  }
  
  @objc func dismissKeyboard() {
    emailTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
  }
  
  @objc func transitionToSignUp() {
    let signUpViewController = SignUpViewController()
    present(signUpViewController, animated: true, completion: nil)
  }

  @objc func signInAccount() {
    guard let email = emailTextField.text, let password = passwordTextField.text else { return }
    if email.isEmpty && password.isEmpty {
      let emptyTextFieldAlert = FactoryManager.shared.alertManager.addAlert(message: "Please enter your email or password")
      present(emptyTextFieldAlert, animated: true, completion:  nil)
    } else {
      FactoryManager.shared.firebaseManager.signInAccount(email: email, password: password, success: { (user) in
        print(user)
        let marvelTabBarController = MarvelTabBarController()
        let navigationController = UINavigationController(rootViewController: marvelTabBarController)
        self.present(navigationController, animated: true, completion: nil)
      }) { (error) in
        let errorAlert = FactoryManager.shared.alertManager.addAlert(message: error)
        self.present(errorAlert, animated: true, completion:  nil)
        print(error)
      }
    }
  }
  
}

extension SignInViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
