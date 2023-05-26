//
//  Extensions.swift
//  ImageMerger
//
//  Created by Naveen on 26/05/23.
//

import Foundation
import UIKit
import PhotosUI

extension UIImagePickerController{
    
    func validatePermission(_ pickerType:UIImagePickerController.SourceType,_ hasPermission:((_ avilable:Bool,_ isNew:Bool)->Void)?){
        if pickerType == .camera {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    hasPermission?(granted,true)
                }
            case .denied: // The user has previously denied access.
                hasPermission?(false,false)
            case .authorized:
                hasPermission?(true,false)
            default:
                break
            }
        }else if pickerType == .photoLibrary {
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined: // The user has not yet been asked for camera access.
                PHPhotoLibrary.requestAuthorization { granted in
                    hasPermission?((granted == .authorized),true)
                }
            case .denied: // The user has previously denied access.
                hasPermission?(false,false)
            case .authorized:
                hasPermission?(true,false)
            default:
                break
            }
        }
    }
}

extension UIViewController{
    func showAlert(with title: String, and message: String, buttonOneName:String, buttonTwoName:String = "",btn1Action:(()->Void)? = nil,btn2Action:(()->Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if(!buttonOneName.isEmpty){
            alertController.addAction(UIAlertAction(title: buttonOneName, style: UIAlertAction.Style.cancel, handler: { (_) in
                btn1Action?()
            }))
        }
        if(!buttonTwoName.isEmpty){
            alertController.addAction(UIAlertAction(title: buttonTwoName, style: UIAlertAction.Style.default, handler: { (_) in
                btn2Action?()
            }))
        }
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlertSheetView(with titles: [String], and message: String, cancelBtnName:String = "",chooseAction:((_ selected:String)->Void)? = nil, cancelAction:(()->Void)? = nil){
        let alertController = UIAlertController(title: nil, message: message.isEmpty ? nil : message, preferredStyle: .actionSheet)
           for itemTitle in titles {
               let titleAction = UIAlertAction(title: itemTitle, style: .default, handler: {
                   (alert: UIAlertAction!) -> Void in
                   chooseAction?(alert.title ?? "")
               })
               alertController.addAction(titleAction)
           }
           if(!cancelBtnName.isEmpty){
               let cancelAction = UIAlertAction(title: cancelBtnName, style: .cancel, handler: {_ in
                   cancelAction?()
               })
               cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
               
               alertController.addAction(cancelAction)
           }
           
           // Present Alert Controller
           present(alertController, animated: true, completion: nil)
       }

}
