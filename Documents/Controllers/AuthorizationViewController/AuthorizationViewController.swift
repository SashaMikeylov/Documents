//
//  AuthorizationViewController.swift
//  Documents
//
//  Created by Денис Кузьминов on 07.10.2023.
//

import Foundation
import UIKit

final class AuthorizationViewController: UIViewController {
    
    
    let authorizationView = AuthorizationView()
    
//MARK: -Life
    
    override func loadView() {
        super.loadView()
        view = authorizationView
        authorizationView.checkStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizationView.delegate = self
        authorizationView.navigayionController = navigationController
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.tabBarController?.tabBar.isHidden = true
    }

//MARK: - Func
    
    private func showWrongRepeatPassword() {
        let alertViewController = UIAlertController(title: "Wrong repeat password", message: "Your password is different from the previous one", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Try again", style: .cancel)
        alertViewController.addAction(alertAction)
        present(alertViewController, animated: true)
    }
    
    private func showWrongPassword() {
        let alertController = UIAlertController(title: "Wrong password", message: "Your password is wrong", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Try again", style: .cancel)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}


//MARK: - Extenshions

extension AuthorizationViewController: AuthorizationViewDelegate {
    
    func alertChecker() {
        if authorizationView.alertMessage == .wrongRepeatPassword {
            showWrongRepeatPassword()
        } else if authorizationView.alertMessage == .wrongPassword {
            showWrongPassword()
        }
    }
}
