//
//  ResultImageViewController.swift
//  ImageMerger
//
//  Created by Naveen on 26/05/23.
//

import UIKit

class ResultImageViewController: UIViewController {
    
    @IBOutlet weak var resultImgView:UIImageView!
    @IBOutlet weak var errorLbl:UILabel!
    @IBOutlet weak var loader:UIActivityIndicatorView!
    
    var combinedImgPath:URL?
    lazy var queue = DispatchQueue.main
    
    convenience init(combinedImgPath:URL?) {
        self.init(nibName: "ResultImageViewController", bundle: nil)
        self.combinedImgPath = combinedImgPath
    }
    
    fileprivate func updateUI() {
        if let combinedImgPath = combinedImgPath,let image = try? UIImage(data: Data(contentsOf: combinedImgPath.absoluteURL)) {
            resultImgView.image = image
            errorLbl.isHidden = true
        }else{
            errorLbl.isHidden = false
            resultImgView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(tappedReset))
        loader.startAnimating()
        updateUI()
        loader.stopAnimating()
    }
    
    @objc func tappedReset(){
        //TODO: remove File From local storage
        if let combinedImgPath = combinedImgPath {
            try? FileManager.default.removeItem(at: combinedImgPath)
        }
        navigationController?.popToRootViewController(animated: true)
    }
}
