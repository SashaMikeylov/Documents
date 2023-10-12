//
//  SettingsViewController.swift
//  Documents
//
//  Created by Денис Кузьминов on 08.10.2023.
//

import Foundation
import UIKit

final class SettingsViewController: UIViewController {
    
   let settingsView = SettingsView()
    
//MARK: - Life
    
    override func loadView() {
        super.loadView()
        view = settingsView
        settingsView.navigationController = navigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
