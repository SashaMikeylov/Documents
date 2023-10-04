//
//  DocumentsViewController.swift
//  Documents
//
//  Created by Денис Кузьминов on 03.10.2023.
//

import UIKit
import PhotosUI

var fille: [String] = []

final class DocumentsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let documentsView = DocumentsView()
    var name = ""
    
    
//MARK: -Life
    
    override func loadView() {
        super.loadView()
        view = documentsView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSetUp()
        barSettings()
        title = "Documents"
        navigationController?.navigationBar.prefersLargeTitles = true
        documentsView.reloadTable()
    }
    
//MARK: -Func
    
    private func tableSetUp() {
        documentsView.tableSettings(dataSource: self, delegate: self)
    }

    private func barSettings(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonAction))
    }
    
    private func showAlerts() {
        
        let allertController = UIAlertController(title: "Create image", message: "", preferredStyle: .alert)
        allertController.addTextField() { textField in
            textField.placeholder = "Image name"
        }
        let allertBUtton = UIAlertAction(title: "Create", style: .default) {[weak self] action in
            self?.name = allertController.textFields?.first?.text ?? ""
            self?.showPicker()
        }
        let allertButton1 = UIAlertAction(title: "Cancel", style: .cancel)
        allertController.addAction(allertButton1)
        allertController.addAction(allertBUtton)
        present(allertController, animated: true)
    }
    
    private func showPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            FileManagerService().addPhoto(photo: image, name: name)
        }
        
        self.dismiss(animated: true) { [weak self] in
            self?.documentsView.reloadTable()
        }
        
    }
    
//MARK: -Objc Func
    
    @objc private func barButtonAction() {
        showAlerts()
    }
    
}

//MARK: -Extenshions

extension DocumentsViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FileManagerService().allFiles().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableCellIndetifier", for: indexPath)
        
        cell.textLabel?.text = FileManagerService().allFiles()[indexPath.row]
        cell.accessoryType = .none
        
        
        return cell
    }
}


