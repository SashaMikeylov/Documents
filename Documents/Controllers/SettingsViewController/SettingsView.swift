//
//  SettingsView.swift
//  Documents
//
//  Created by Денис Кузьминов on 11.10.2023.
//

import Foundation
import UIKit

final class SettingsView: UIView {
    
    var navigationController: UINavigationController?
    
    private lazy var settingsFirstView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var settingsSecondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var sortSwitchView: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.addTarget(self, action: #selector(switchViewAction), for: .touchUpInside)
        if FileManagerService().userDefaults.bool(forKey: "settings") {
            switchView.isOn = true
        } else {
            switchView.isOn = false
        }
        
        return switchView
    }()
    
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sort files alphabetically"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        
        return label
    }()
    
    private lazy var describeSortLabel: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "This setting allows you to sort files in alphabetical and reverse order. Turn on - alphabetical order, Turn off - reverse order "
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textColor = .systemGray2
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    private lazy var reloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reload your password", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        button.makeActionAnimate()
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Life
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func
    
    private func layout() {
        
        addSubview(settingsFirstView)
        addSubview(settingsSecondView)
        settingsFirstView.addSubview(sortSwitchView)
        settingsFirstView.addSubview(sortLabel)
        addSubview(describeSortLabel)
        settingsSecondView.addSubview(reloadButton)
        
        NSLayoutConstraint.activate([
            
            settingsFirstView.topAnchor.constraint(equalTo: topAnchor, constant: 200),
            settingsFirstView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            settingsFirstView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            settingsFirstView.heightAnchor.constraint(equalToConstant: 80),
            
            describeSortLabel.topAnchor.constraint(equalTo: settingsFirstView.bottomAnchor, constant: 10),
            describeSortLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            describeSortLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            describeSortLabel.heightAnchor.constraint(equalToConstant: 80),
            
            settingsSecondView.topAnchor.constraint(equalTo: describeSortLabel.bottomAnchor, constant: 20),
            settingsSecondView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            settingsSecondView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            settingsSecondView.heightAnchor.constraint(equalToConstant: 80),
            
            sortSwitchView.centerYAnchor.constraint(equalTo: settingsFirstView.centerYAnchor),
            sortSwitchView.trailingAnchor.constraint(equalTo: settingsFirstView.trailingAnchor, constant: -20),
            
            sortLabel.centerYAnchor.constraint(equalTo: settingsFirstView.centerYAnchor),
            sortLabel.leadingAnchor.constraint(equalTo: settingsFirstView.leadingAnchor, constant: 10),
            
            reloadButton.centerXAnchor.constraint(equalTo: settingsSecondView.centerXAnchor),
            reloadButton.centerYAnchor.constraint(equalTo: settingsSecondView.centerYAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: 300),
            reloadButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
//MARK: - Objc func
    
    @objc private func buttonAction() {
        let viewController = RealodViewController()
        navigationController?.present(viewController, animated: true)
    }
    
    @objc private func switchViewAction() {
        if sortSwitchView.isOn {
            FileManagerService().userDefaults.set(true, forKey: "settings")
        } else {
            FileManagerService().userDefaults.set(false, forKey: "settings")
        }
    }
}
