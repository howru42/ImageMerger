//
//  ImageSelectionViewControllerTest.swift
//  ImageMergerTests
//
//  Created by Naveen on 26/05/23.
//

import XCTest
@testable import ImageMerger

final class ImageSelectionViewControllerTest: XCTestCase {
    
    
    func test_viewDidLoad_initial() throws {
        let sut = ImageSelectionViewController()
        _ = sut.view
        sut.selectedImages = []
        XCTAssertFalse(sut.chooseImgsBtn.isHidden)
        XCTAssertTrue(sut.countLbl.isHidden)
        XCTAssertTrue(sut.resetBtn.isHidden)
        XCTAssertTrue(sut.addMoreBtn.isHidden)
    }
    
    func test_viewDidLoad_btnTitle() throws {
        let sut = ImageSelectionViewController()
        _ = sut.view
        
        sut.selectedImages = []
        XCTAssertEqual(sut.chooseImgsBtn.title(for: .normal), "Choose Image(s)")
        
        sut.selectedImages = [URL(filePath: "")]
        XCTAssertEqual(sut.chooseImgsBtn.title(for: .normal), "Combine Images")
        XCTAssertFalse(sut.countLbl.isHidden)
        XCTAssertEqual("1 Image(s) selected",sut.countLbl.text)
    }
    
}
