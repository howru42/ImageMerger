//
//  ImageSelectionViewModel.swift
//  ImageMerger
//
//  Created by Naveen on 26/05/23.
//

import Foundation
import UIKit

class ImageSelectionViewModel{
    var isLoading:Observable<Bool> = Observable(value: false)
    let storage: Storage
    
    init(fileStorage: Storage) {
        self.storage = fileStorage
    }
    
    func getCombinedImgPath(forImgs imgs: Set<URL>?) -> URL? {
        guard let imgs = imgs else { return nil }
        isLoading.set(value: true)
        if let resultImg = combineImages(imgs){
            let path = storeIntoLocal(image: resultImg,title:"Combined_image")
            isLoading.set(value: false)
            return path
        }
        return nil
    }
    
    func storeIntoLocal(image: UIImage?,title:String) -> URL? {
        guard let image = image else { return nil }
        return storage.store(image: image,title: title)
    }
    
    private func combineImages(_ imageUrls: Set<URL>? = nil) -> UIImage? {
        guard let imageUrls = imageUrls else { return nil }
        let images = imageUrls.map({storage.loadImage(url: $0)})
        let newImageWidth  = images.map({$0?.size.width ?? 0}).reduce(0, +)
        let newImageHeight = images.map({$0?.size.height ?? 0}).reduce(0, +)
        let newImageSize = CGSize(width : newImageWidth, height: newImageHeight)
        
        
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.main.scale)
        var xPos:CGFloat = 0
        
        for image in images {
            if let image = image {
                image.draw(at: CGPoint(x: xPos, y: 0))
                xPos += image.size.width
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        return image
    }
    
}

protocol Storage {
    func store(image: UIImage,title:String) -> URL?
    func loadImage(url:URL?) -> UIImage?
}

extension Storage{
    func loadImage(url:URL?) -> UIImage?{
        return nil
    }
}

class FileStorage: Storage {
    func store(image: UIImage,title:String) -> URL? {
        do{
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(title,isDirectory: false)
            if let data = image.jpegData(compressionQuality: 0.8) {
                try data.write(to: fileURL, options: .atomic)
            }
            return fileURL
        }catch(let error){
            debugPrint("...error...\(error.localizedDescription)")
            return nil
        }
    }
    
    func loadImage(url:URL?) -> UIImage? {
        guard let url = url else { return nil }
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}
