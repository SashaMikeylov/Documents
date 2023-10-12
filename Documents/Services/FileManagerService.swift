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
    func allFiles() -> [String]
    func addPhoto(photo: UIImage, name: String?)
    func deleteFile(file: URL)
    func allUrls() -> [URL]
    func catchImage(fileName: String) -> UIImage
}


//MARK: -FileManager

final class FileManagerService: FileManagerServiceProtocol {

    let fileManager = FileManager.default
    let userDefaults = UserDefaults.standard
    
 //MARK: - All Urls
    
    func allUrls() -> [URL] {
        var urls: [URL] = []
        
        do {
            let documentaryUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let content = try fileManager.contentsOfDirectory(at: documentaryUrl, includingPropertiesForKeys: nil, options: [])
            urls = content
        } catch {
            print(error.localizedDescription)
        }
        return urls
    }
    
//MARK: - All files
    
    func allFiles() -> [String] {
        var files: [String] = []
        do {
            let documentsUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let allFiles = try fileManager.contentsOfDirectory(atPath: documentsUrl.path)
            files = allFiles
        } catch {
            print(error.localizedDescription)
        }
        
        
        if userDefaults.bool(forKey: "settings") {
            return files.sorted(by: <)
        }
        return files.sorted(by: >)
        
    }
    
//MARK: -  Add file
    
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
    
//MARK: - Delete file
    
    func deleteFile(file: URL)  {
        do {
           try fileManager.removeItem(at: file)
        } catch {
            print(error.localizedDescription)
        }
    }
    
//MARK: - Catch image
    
    func catchImage(fileName: String) -> UIImage {
        var finalImage: UIImage = UIImage()
        
        do {
            let documentsUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let imagePath = documentsUrl.appending(component: fileName)
            if fileManager.fileExists(atPath: imagePath.path) {
                let data = try Data(contentsOf: imagePath)
                guard  let image = UIImage(data: data) else {return UIImage()}
                finalImage = image
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return finalImage
    }
}
