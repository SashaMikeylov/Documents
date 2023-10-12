//
//  Enums.swift
//  Documents
//
//  Created by Денис Кузьминов on 10.10.2023.
//

import Foundation


enum UserState {
    case notAuthoriz
    case savedPassword
    case reloadData
}

enum ButtonState {
    case firstPassword
    case repeatPassword
}

enum AlertsName {
    case wrongPassword
    case wrongRepeatPassword
}

enum ModalScreenSyle {
    case normal
    case reload
}
