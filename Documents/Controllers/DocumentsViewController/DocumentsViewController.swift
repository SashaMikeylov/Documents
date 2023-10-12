//
//  DocumentsViewController.swift
//  Documents
//
//  Created by Денис Кузьминов on 03.10.2023.
//

import UIKit
import PhotosUI


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
        navigationController?.tabBarController?.tabBar.isHidden = false
        navigationItem.hidesBackButton = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        documentsView.reloadTable()
    }
    
//MARK: -Func
    
    private func tableSetUp() {
        documentsView.tableSettings(dataSource: self, delegate: self)
    }

    private func barSettings(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonAction))
    }
    
    private func showErrorAllert() {
        let allertController = UIAlertController(title: "This name is used ", message: "Try other name", preferredStyle: .alert)
        let allertAction = UIAlertAction(title: "Try", style: .cancel)
        allertController.addAction(allertAction)
        present(allertController, animated: true)
    }
    
//MARK: - Show alerts
    
    private func showAlerts() {
        
        let allertController = UIAlertController(title: "Create image", message: "", preferredStyle: .alert)
        allertController.addTextField() { textField in
            textField.placeholder = "Image name"
        }
        
        let allertBUtton = UIAlertAction(title: "Create", style: .default) { [weak self] action in
            if FileManagerService().allFiles().count != 0 {
                for fileName in FileManagerService().allFiles() {
                    if (allertController.textFields?.first?.text ?? "") + ".png" != fileName {
                        self?.name = allertController.textFields?.first?.text ?? ""
                        self?.showPicker()
                        break
                    } else {
                        self?.showErrorAllert()
                        break
                    }
                }
            } else {
                self?.name = allertController.textFields?.first?.text ?? ""
                self?.showPicker()
            }
        }
        
        let allertButton1 = UIAlertAction(title: "Cancel", style: .cancel)
        allertController.addAction(allertButton1)
        allertController.addAction(allertBUtton)
        present(allertController, animated: true)
    }
    
//MARK: - Image Picker
    
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
        var content = cell.defaultContentConfiguration()
        if let image = UIImage(contentsOfFile: FileManagerService().allUrls()[indexPath.row].path) {
            content.image = image
            content.text = FileManagerService().allFiles()[indexPath.row]
        }
        cell.contentConfiguration = content
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FileManagerService().deleteFile(file: FileManagerService().allUrls()[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(200)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = FileManagerService().catchImage(fileName: FileManagerService().allFiles()[indexPath.row] )
        let detailViewController = DetailsViewContoller(image: image)
        detailViewController.modalPresentationStyle = .automatic
        present(detailViewController, animated: true)
    }
}


