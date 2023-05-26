//
//  ImageSelectionViewController.swift
//  ImageMerger
//
//  Created by Naveen on 26/05/23.
//

import UIKit

class ImageSelectionViewController: UIViewController {
    lazy var viewModel:ImageSelectionViewModel = ImageSelectionViewModel(fileStorage: FileStorage())
    
    @IBOutlet weak var countLbl:UILabel!
    @IBOutlet weak var chooseImgsBtn:UIButton!
    @IBOutlet weak var resetBtn:UIButton!
    @IBOutlet weak var addMoreBtn:UIButton!
    @IBOutlet weak var loader:UIActivityIndicatorView!
    
    var selectedImages:Set<URL> = []{
        didSet{
            updateUI()
        }
    }
    
    convenience init() {
        self.init(nibName: "ImageSelectionViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedImages = []
        viewModel.isLoading.bind { [weak self] status in
            DispatchQueue.main.async {
                if(status){
                    self?.loader.startAnimating()
                }else{
                    self?.loader.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func tapPrimaryBtn(_ sender:UIButton){
        if(selectedImages.isEmpty){
            showPicker()
        }else{
            loader.startAnimating()
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                guard let resultImgPath = viewModel.getCombinedImgPath(forImgs: selectedImages) else {return}
                navigateToResult(resultImgPath)
            }
        }
    }
    
    private func navigateToResult(_ resultImgPath:URL){
        DispatchQueue.main.async { [weak self] in
            let controller = ResultImageViewController(combinedImgPath: resultImgPath)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func tapAddMore(_ sender:UIButton){
        showPicker()
    }
    
    @IBAction func tapReset(_ sender:UIButton){
        selectedImages = []
    }
    
    private func updateUI(){
        let hidden = selectedImages.isEmpty
        countLbl.isHidden = hidden
        resetBtn.isHidden = hidden
        addMoreBtn.isHidden = hidden
        chooseImgsBtn.setTitle(hidden ? "Choose Image(s)" : "Combine Images", for: .normal)
        countLbl.text = "\(selectedImages.count) Image(s) selected"
    }
    
    private func showPicker(){
        showAlertSheetView(with: ["Camera","Pick from gallery"], and: "",cancelBtnName: "Dismiss") { [weak self] selected in
            self?.capture(sourceType: selected == "Camera" ? .camera : .photoLibrary)
        }
    }
    
    private func capture(sourceType:UIImagePickerController.SourceType){
        
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = false
        imgPicker.sourceType = sourceType
        imgPicker.validatePermission(sourceType) { [weak self] (hasPermission, _) in
            DispatchQueue.main.async {
                if(hasPermission){
                    if(sourceType == .camera){
                        imgPicker.showsCameraControls = true
                    }
                    self?.present(imgPicker, animated: true, completion: nil)
                }else{
                    let erroMsg = sourceType == .camera ? "Camera permission required to capture images." :
                    "PhotoLibrary permission required to pick images"
                    self?.showAlert(with:erroMsg,and: "", buttonOneName: "Dismiss", buttonTwoName: "Settings")
                }
            }
        }
    }
}

extension ImageSelectionViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imgURL = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            selectedImages.insert(imgURL)
        }else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let imgTitle = "\(Int64.random(in: 0...INT64_MAX)).jpeg"
            if let storedUrl = viewModel.storeIntoLocal(image: img, title: imgTitle){
                selectedImages.insert(storedUrl)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

