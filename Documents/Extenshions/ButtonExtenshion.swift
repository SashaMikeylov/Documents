//
//  ButtonExtenshion.swift
//  Documents
//
//  Created by Денис Кузьминов on 10.10.2023.
//

import Foundation
import UIKit

extension UIButton {
    
    func activeButton(activate: Bool) {
        if activate {
            isEnabled = true
            alpha = 1
        } else {
            isEnabled = false
            alpha = 0.5
        }
    }
    
    func makeActionAnimate() {
        
        addTarget(self, action: #selector(holdOn), for: [
            .touchDown,
            .touchDragInside
        ])
        
        addTarget(self, action: #selector(holdOff), for: [
            .touchCancel,
            .touchUpOutside,
            .touchDragExit,
            .touchDragOutside,
            .touchUpInside
        ])
    }
    
    @objc private func holdOn() {
        UIView.animate(withDuration: 0.1, animations: { self.alpha = 0.7 })
    }
    
    @objc private func holdOff() {
        UIView.animate(withDuration: 0.1, animations: { self.alpha = 1 })
    }
    
}
