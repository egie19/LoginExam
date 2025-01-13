//
//  LoginViewController.swift
//  LoginExam
//
//  Created by Lowiegie Oblenida on 1/11/25.
//

import UIKit

class LoginViewController: UIViewController, KeyboardObservable {
    
    var viewModel = LoginViewModel()
    var keyboardObserver: KeyboardObserver?
    var hasFrameAdjusted: Bool = false
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        setupButtons()
        
        startKeyboardObserving { [weak self] (keyboardFrame) in
            guard let self else { return }
            if UIDevice.current.orientation.isLandscape {
                if !self.hasFrameAdjusted {
                    UIView.animate(withDuration: 0.1) {
                        self.view.frame.origin.y = self.view.frame.origin.y - 100
                        self.hasFrameAdjusted = true
                        self.btnLogin.isHidden = true
                    }
                }
            } else {
                if self.hasFrameAdjusted {
                    UIView.animate(withDuration: 0.1) { [weak self] in
                        guard let self else { return }
                        self.view.frame.origin.y = 0
                        self.hasFrameAdjusted = false
                        self.btnLogin.isHidden = false
                    }
                }
            }
            
        } onHide: {
            if self.hasFrameAdjusted {
                UIView.animate(withDuration: 0.1) { [weak self] in
                    guard let self else { return }
                    self.view.frame.origin.y = 0
                    self.hasFrameAdjusted = false
                    self.btnLogin.isHidden = false
                }
            }
            
        }
        
    }
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        viewModel.login(username: txtUsername.text!, password: txtPassword.text!, completion: {
            [weak self] (success, data) in
            if (success) {
                DispatchQueue.main.async {
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                    vc.viewModel = WelcomeViewModel(userModel: data!)
                    let navController = UINavigationController(rootViewController: vc)
                    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                    sceneDelegate?.window?.rootViewController = navController
                    sceneDelegate?.window?.makeKeyAndVisible()
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        })
        
    }
    
    
    
    @IBAction func btnPasswordTapped(_ sender: UIButton) {
        txtPassword.isSecureTextEntry.toggle()
        sender.setImage(txtPassword.isSecureTextEntry ? UIImage(named: "eyesHidden") : UIImage(named: "eyesShow"), for: .normal)
    }
    
    
    private func setupButtons() {
        btnLogin.layer.cornerRadius = 10
        btnLogin.isEnabled = false
    }
    
    private func setupTextFields() {
        txtUsername.delegate = self
        txtPassword.delegate = self
        txtUsername.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        btnLogin.isEnabled = txtUsername.hasText && txtPassword.hasText
    }
}
