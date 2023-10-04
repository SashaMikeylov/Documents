//
//  DocumentsView.swift
//  Documents
//
//  Created by Денис Кузьминов on 03.10.2023.
//

import Foundation
import UIKit

final class DocumentsView: UIView {
    
    
     lazy var tableDocumentsView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        
        
        return table
    }()
    
//MARK: -Life
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: -Func
    
    private func layout() {
        
        addSubview(tableDocumentsView)
        
        
        NSLayoutConstraint.activate([
            tableDocumentsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            tableDocumentsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableDocumentsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableDocumentsView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func tableSettings(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        
        tableDocumentsView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultTableCellIndetifier")
        tableDocumentsView.dataSource = dataSource
        tableDocumentsView.delegate = delegate
    }
    
    func reloadTable() {
        tableDocumentsView.reloadData()
    }
    
}

