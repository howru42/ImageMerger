//
//  ImageSelectionViewModelTest.swift
//  ImageMergerTests
//
//  Created by Naveen on 26/05/23.
//

import XCTest
@testable import ImageMerger

final class ImageSelectionViewModelTest: XCTestCase {
    var storage = StorageSpy()
    
    func test_mergeImgPath_without_images(){
        XCTAssertNil(makeSUT().getCombinedImgPath(forImgs: nil))
        XCTAssertNil(makeSUT().getCombinedImgPath(forImgs: []))
    }
    
    func test_store_image(){
        XCTAssertNil(makeSUT().storeIntoLocal(image: nil,title: ""))
        XCTAssertNil(makeSUT().storeIntoLocal(image: UIImage(named: ""),title: ""))
    }
    
    func test_load_image(){
        XCTAssertNil(makeSUT().storeIntoLocal(image: nil,title: ""))
        XCTAssertNil(makeSUT().storeIntoLocal(image: UIImage(named: ""),title: ""))
    }
    
    //Helper
    func makeSUT() -> ImageSelectionViewModel {
        return ImageSelectionViewModel(fileStorage: storage)
    }    
}
class StorageSpy: Storage{
    func loadImage(url: URL?) -> UIImage? {
        guard let _ = url else { return nil }
        return UIImage(systemName: "square.and.arrow.up")
    }
    
    func store(image: UIImage,title:String) -> URL? {
        return URL(string: "mockImgFilePath")
    }
}
