//
//  AuthorizationView.swift
//  Documents
//
//  Created by Денис Кузьминов on 07.10.2023.
//

import Foundation
import UIKit


protocol AuthorizationViewDelegate: UIViewController {
    func alertChecker ()
}

final class AuthorizationView: UIView {
    
    var alertMessage: AlertsName?
    var state: UserState?
    var modalStyle: ModalScreenSyle?
    var navigayionController: UINavigationController?
    weak var delegate: AuthorizationViewDelegate?
    
    private var buttonState: ButtonState = .firstPassword
    private var firstPassword = ""
    private var secondPassword = ""
    
    private lazy var authTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Authorization"
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
    //MARK: -Life
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layout()
        checkStatus()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Func
 
    private  func changeButton() {
        if state == .notAuthoriz {
            passwordButton.setTitle("Create password", for: .normal)
        } else if state == .savedPassword {
            passwordButton.setTitle("Enter password", for: .normal)
        }
    }
    
     func checkStatus() {
        
         if PasswordService().startPassword() {
             state = .savedPassword
         } else {
             state = .notAuthoriz
         }
         changeButton()
    }
    
    private func eraseField() {
        passwordField.text = ""
        passwordButton.activeButton(activate: false)
        checkerPassword.backgroundColor = .red
    }
   
    //MARK: - Layout
    
    private func layout() {
        
        addSubview(authTitle)
        addSubview(fieldView)
        fieldView.addSubview(passwordField)
        addSubview(passwordButton)
        addSubview(checkerPassword)
        addSubview(describeLabel)
        addSubview(documentsImage)

        NSLayoutConstraint.activate([
            
            authTitle.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            authTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            authTitle.widthAnchor.constraint(equalToConstant: 250),
            authTitle.heightAnchor.constraint(equalToConstant: 70),
            
            documentsImage.topAnchor.constraint(equalTo: authTitle.bottomAnchor, constant: 30),
            documentsImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            documentsImage.heightAnchor.constraint(equalToConstant: 100),
            documentsImage.widthAnchor.constraint(equalToConstant: 100),
            
            fieldView.centerXAnchor.constraint(equalTo: centerXAnchor),
            fieldView.topAnchor.constraint(equalTo: documentsImage.bottomAnchor, constant: 120),
            fieldView.widthAnchor.constraint(equalToConstant: 250),
            fieldView.heightAnchor.constraint(equalToConstant: 50),
            
            passwordButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 60),
            passwordButton.centerXAnchor.constraint(equalTo: centerXAnchor),
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
            describeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
//MARK: - Not auth action
    
    private func buttonNotAuthAction() {
        
        if buttonState == .firstPassword {
            let password = passwordField.text ?? ""
            firstPassword = password
            eraseField()
            passwordButton.setTitle("Repeat password", for: .normal)
            passwordField.placeholder = " Repeat password"
            buttonState = .repeatPassword
            
        } else if buttonState == .repeatPassword {
            let password = passwordField.text ?? ""
            secondPassword = password
            if firstPassword == secondPassword {
                let viewController = DocumentsViewController()
                navigayionController?.pushViewController(viewController, animated: true)
                PasswordService().savePassword(password: passwordField.text ?? "")
                eraseField()
                passwordField.placeholder = " Enter password"
                passwordButton.setTitle("Create password", for: .normal)
                buttonState = .firstPassword
                
            } else {
                eraseField()
                passwordField.placeholder = " Enter password"
                passwordButton.setTitle("Create password", for: .normal)
                buttonState = .firstPassword
                alertMessage = .wrongRepeatPassword
                delegate?.alertChecker()
            }
        }
    }
//MARK: - Saved password action
    
    private func buttonSavedAction() {
        let userPassword = passwordField.text ?? ""
        if PasswordService().checkPassword(password: userPassword) {
            let viewController = DocumentsViewController()
            navigayionController?.pushViewController(viewController, animated: true)
            eraseField()
        } else {
            alertMessage = .wrongPassword
            delegate?.alertChecker()
            eraseField()
        }
    }
    
//MARK: -Objc func
    
    @objc private func buttonPressed() {
        if state == .notAuthoriz {
            buttonNotAuthAction()
        } else if state == .savedPassword {
            buttonSavedAction()
        } else if state == .reloadData {
            navigayionController?.dismiss(animated: true)
        }
    }
}

//MARK: - Extensions
    
extension AuthorizationView: UITextFieldDelegate {
    
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
