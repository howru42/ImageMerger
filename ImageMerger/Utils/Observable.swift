//
//  Observable.swift
//  ImageMerger
//
//  Created by Naveen on 26/05/23.
//

import Foundation

struct Observable<T> {
    private var value: T {
        didSet {
            action?(value)
        }
    }
    
    typealias Action = (T) -> Void
    
    private var action : Action?
    
    init(value: T) {
        self.value = value
    }
    
    mutating func set(value: T) {
        self.value = value
    }
    
    mutating func bind(action: @escaping Action) {
        self.action = action
    }
}
