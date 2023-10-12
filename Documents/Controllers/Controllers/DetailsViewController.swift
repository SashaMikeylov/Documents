//
//  DetailsViewController.swift
//  Documents
//
//  Created by Денис Кузьминов on 08.10.2023.
//

import Foundation
import UIKit

final class DetailsViewContoller: UIViewController {
    
   private var image: UIImage
    
    private var imageView = UIImageView()
    
//MARK: - Life

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
    }
   
    init(image: UIImage) {
        self.image = image
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 //MARK: - Func
    
    private func layout() {
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
    }
    
}
