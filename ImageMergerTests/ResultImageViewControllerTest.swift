//
//  ResultImageViewControllerTest.swift
//  ImageMergerTests
//
//  Created by Naveen on 26/05/23.
//

import Foundation
import XCTest
@testable import ImageMerger

class ResultImageViewControllerTest: XCTestCase {
    
    func test_viewDidLoad_withImagePath(){
        let storage = FileStorage()
        let path = storage.store(image: UIImage(systemName: "square.and.arrow.up")!, title: "dummyImgPath")
        let sut = ResultImageViewController(combinedImgPath: path)
        _ = sut.view
        XCTAssertTrue(sut.errorLbl.isHidden)
        XCTAssertFalse(sut.resultImgView.isHidden)
    }
    
    func test_viewDidLoad_withoutImagePath(){
        let sut = ResultImageViewController(combinedImgPath: nil)
        _ = sut.view
        XCTAssertFalse(sut.errorLbl.isHidden)
        XCTAssertTrue(sut.resultImgView.isHidden)
    }
    
}
