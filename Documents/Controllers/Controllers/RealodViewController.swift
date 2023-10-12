//
//  RealodViewController.swift
//  Documents
//
//  Created by Денис Кузьминов on 12.10.2023.
//

import Foundation
import UIKit

final class RealodViewController: UIViewController {
    
    private var buttonState: ButtonState = .firstPassword
    private var firstPassword = ""
    private var secondPassword = ""
    
    private lazy var authTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Realod password"
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        label.backgroundColor = .clear
        label.textColor = .black
        
        
        return label
    }()
    
    
    private lazy var fieldView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = " Enter password"
        field.backgroundColor = .clear
        field.delegate = self
        
        return field
    }()
    
    private lazy var passwordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.setTitle("Create password", for: .normal)
        button.makeActionAnimate()
        
        return button
    }()
    
    private lazy var checkerPassword: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7.5
        view.backgroundColor = .red
        
        return view
        
    }()
    
    private lazy var describeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The password must contain at least 4 characters"
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        return label
    }()
    
    private lazy var documentsImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "documentsImage")
        
        return image
    }()
    
//MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
       
    }
    
//MARK: - Layout
    
    private func layout() {
        
        view.addSubview(authTitle)
        view.addSubview(fieldView)
        fieldView.addSubview(passwordField)
        view.addSubview(passwordButton)
        view.addSubview(checkerPassword)
        view.addSubview(describeLabel)
        view.addSubview(documentsImage)

        NSLayoutConstraint.activate([
            
            authTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            authTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authTitle.heightAnchor.constraint(equalToConstant: 70),
            
            documentsImage.topAnchor.constraint(equalTo: authTitle.bottomAnchor, constant: 30),
            documentsImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            documentsImage.heightAnchor.constraint(equalToConstant: 100),
            documentsImage.widthAnchor.constraint(equalToConstant: 100),
            
            fieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fieldView.topAnchor.constraint(equalTo: documentsImage.bottomAnchor, constant: 120),
            fieldView.widthAnchor.constraint(equalToConstant: 250),
            fieldView.heightAnchor.constraint(equalToConstant: 50),
            
            passwordButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 60),
            passwordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordButton.widthAnchor.constraint(equalToConstant: 250),
            passwordButton.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.topAnchor.constraint(equalTo: fieldView.topAnchor),
            passwordField.bottomAnchor.constraint(equalTo: fieldView.bottomAnchor),
            passwordField.leadingAnchor.constraint(equalTo: fieldView.leadingAnchor, constant: 8),
            passwordField.trailingAnchor.constraint(equalTo: fieldView.trailingAnchor),
                        
            checkerPassword.leftAnchor.constraint(equalTo: passwordField.rightAnchor, constant: 10),
            checkerPassword.heightAnchor.constraint(equalToConstant: 15),
            checkerPassword.widthAnchor.constraint(equalToConstant: 15),
            checkerPassword.topAnchor.constraint(equalTo: passwordField.topAnchor, constant: 15),
            
            describeLabel.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -30),
            describeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
//MARK: - Func
    
    private func buttonAction() {
        
        if buttonState == .firstPassword {
            let password = passwordField.text ?? ""
            firstPassword = password
            cleanFIeld()
            passwordButton.setTitle("Repeat password", for: .normal)
            passwordField.placeholder = " Repeat password"
            buttonState = .repeatPassword
            
        } else if buttonState == .repeatPassword {
            let password = passwordField.text ?? ""
            secondPassword = password
            if firstPassword == secondPassword {
                dismiss(animated: true)
                PasswordService().reloadPassword(password: password)
                cleanFIeld()
                passwordField.placeholder = " Enter password"
                passwordButton.setTitle("Create password", for: .normal)
                buttonState = .firstPassword
                
            } else {
                showAlerts()
                cleanFIeld()
                passwordField.placeholder = " Enter password"
                passwordButton.setTitle("Create password", for: .normal)
                buttonState = .firstPassword
            }
        }
    }
    
    private func cleanFIeld() {
        passwordField.text = ""
        passwordButton.activeButton(activate: false)
        checkerPassword.backgroundColor = .red
    }
    
    private func showAlerts() {
        let alertController = UIAlertController(title: "Wrong password", message: "Your password is different from the previous one", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Try again", style: .cancel)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
//MARK: - Objc func
    
    @objc private func buttonPressed() {
        buttonAction()
    }
}

//MARK: - Extenshions

extension RealodViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if textField.text?.count ?? 0 < 4 {
            checkerPassword.backgroundColor = .red
            passwordButton.activeButton(activate: false)
        } else {
            checkerPassword.backgroundColor = .green
            passwordButton.activeButton(activate: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
