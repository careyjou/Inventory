//
//  Stack.swift
//  Inventory
//
//  Created by Vincent Spitale on 5/31/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation


/// Represents a stack of elements of type T.
/// Used when position was dependent on a tree of images.
public struct Stack<T> {
    fileprivate var array: [T] = []
    
    public init() {}
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public func isEmpty() -> Bool {
        return array.count == 0
    }
}
