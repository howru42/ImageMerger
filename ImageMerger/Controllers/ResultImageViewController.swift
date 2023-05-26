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
    
    convenience init(combinedImgPath:URL?) {
        self.init(nibName: "ResultImageViewController", bundle: nil)
        self.combinedImgPath = combinedImgPath
    }
    
    fileprivate func updateUI() {
        guard let combinedImgPath = combinedImgPath else {
            errorLbl.isHidden = false
            resultImgView.isHidden = true
            return
        }
        errorLbl.isHidden = true
        
        DispatchQueue.global().async {
            let image = try? UIImage(data: Data(contentsOf: combinedImgPath.absoluteURL))
            DispatchQueue.main.async {[weak self] in
                self?.resultImgView.image = image
                self?.loader.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(tappedReset))
        loader.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    @objc func tappedReset(){
        //TODO: remove File From local storage
        if let combinedImgPath = combinedImgPath {
            try? FileManager.default.removeItem(at: combinedImgPath)
        }
        navigationController?.popToRootViewController(animated: true)
    }
}
