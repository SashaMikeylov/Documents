//
//  FileManagerService.swift
//  Documents
//
//  Created by Денис Кузьминов on 03.10.2023.
//

import Foundation
import UIKit

//MARK: -Protocol

protocol FileManagerServiceProtocol {
    func allFiles() -> [String?]
    func addPhoto(photo: UIImage, name: String?)
}


//MARK: -FileManager

final class FileManagerService: FileManagerServiceProtocol {

    let fileManager = FileManager.default
    
    func allFiles() -> [String?] {
        var files: [String?] = []
        do {
            let documentsUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let allFiles = try fileManager.contentsOfDirectory(atPath: documentsUrl.path)
            files = allFiles
            print(documentsUrl)
        } catch {
            print(error.localizedDescription)
        }
        return files
    }
    
    func addPhoto(photo: UIImage, name: String?) {
        
        do {
            let documentsUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let filePath = documentsUrl.appendingPathComponent(name ?? "Unnamed file", conformingTo: .png)
            if let image = photo.jpegData(compressionQuality: 1) {
                fileManager.createFile(atPath: filePath.path, contents: image)
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
