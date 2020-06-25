//
//  ViewController.swift
//  Uber
//
//  Created by JinBae Jeong on 2020/02/21.
//  Copyright © 2020 pino. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
  
  // MARK: - Properties
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "UBER"
    label.font = UIFont(name: "Avenir-Light", size: 36)
    label.textColor = UIColor(white: 1, alpha: 0.8)
    
    return label
  }()
  
  private lazy var emailContainerView: UIView = {
    let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
    view.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return view
  }()
  
  private lazy var passwordContainerView: UIView = {
    let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
    view.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return view
  }()
  
  private let emailTextField: UITextField = {
    return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
  }()
  
  private let passwordTextField: UITextField = {
    return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
  }()
  
  private let loginButton: AuthButton = {
    let button = AuthButton(type: .system)
    button.setTitle("Log In", for: .normal)
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    
    return button
  }()
  
  let dontHaveAccountButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    
    attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
    
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    
    button.setAttributedTitle(attributedTitle, for: .normal)
    return button
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
  }
  
  // MARK: - Selectors
  
  @objc func handleLogin() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      if let error = error {
        print("Failed to register user with error \(error.localizedDescription)")
        return
      }
      
      let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({ $0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
      
      guard let controller = keyWindow?.rootViewController as? HomeController else { return }
      controller.configureUI()
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  @objc func handleShowSignUp() {
    let controller = SignUpController()
    navigationController?.pushViewController(controller, animated: true)
  }
  
  // MARK: - Helper Functions
  
  func configureUI() {
    configureNavigationBar()
    
    view.backgroundColor = .backgroundColor
    
    // addSubView
    view.addSubview(titleLabel)
    
    // Autolayout - Extensions
    titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
    titleLabel.centerX(inView: view)
    
    let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
    stack.axis = .vertical
    stack.distribution = .fillEqually
    stack.spacing = 24
    
    view.addSubview(stack)
    stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
    
    view.addSubview(dontHaveAccountButton)
    dontHaveAccountButton.centerX(inView: view)
    dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
  }
  
  func configureNavigationBar() {
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.barStyle = .black
  }
}

