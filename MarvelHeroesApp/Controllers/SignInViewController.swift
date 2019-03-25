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
  
  lazy var signInButton: UIButton = {
    let signInButton = UIButton()
    signInButton.autoSetDimensions(to: CGSize(width: 70.0, height: 30.0))
    signInButton.setTitle("Sign In", for: .normal)
    signInButton.backgroundColor = UIColor(red: 0 / 255.0, green: 160.0 / 255.0, blue: 0 / 255.0, alpha: 1)
    signInButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14.0)
    
    //signUpButton.addTarget(self, action: #selector(), for: .touchUpInside)
    return signInButton
  }()
  
  lazy var linkToSignUpButton: UIButton = {
    let linkToSignUpButton = UIButton()
    linkToSignUpButton.autoSetDimensions(to: CGSize(width: 70.0, height: 30.0))
    linkToSignUpButton.setTitle("Sign Up", for: .normal)
    linkToSignUpButton.setTitleColor(.blue, for: .normal)
    linkToSignUpButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14.0)
    
    linkToSignUpButton.addTarget(self, action: #selector(transitionToSignUp), for: .touchUpInside)
    return linkToSignUpButton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    addSubviews()
    setupConstraints()
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
  
  @objc func transitionToSignUp() {
    let signUpViewController = SignUpViewController()
    present(signUpViewController, animated: true, completion: nil)
  }

}
