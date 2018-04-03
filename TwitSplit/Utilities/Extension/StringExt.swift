//
//  StringExt.swift
//  TwitSplit
//
//  Created by Thien Huynh on 3/31/18.
//  Copyright © 2018 Thien Huynh. All rights reserved.
//

import Foundation

extension String {
    /// substring from beginning up to index value
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    /// substring from beginning to index value
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    /// substring from index value to ending
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)...]
        }
    }
    
    /// substring from range
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            let indexOfLower = index(startIndex, offsetBy: value.lowerBound)
            let indexOfUper = index(startIndex, offsetBy: value.upperBound)
            return self[indexOfLower...indexOfUper]
        }
    }
    
    /// string character at value index
    subscript(value: Int) -> Substring {
        get {
            let indexOfValue = index(startIndex, offsetBy: value + 1)
            return self[index(before: indexOfValue)..<indexOfValue]
        }
    }
    
    /// from Int to String.Index
    func toIndex(_ value: Int) -> Index {
        return index(startIndex, offsetBy: value)
    }

    /// from String.Index to Int
    func toInt(_ index: Index) -> Int {
        return distance(from: startIndex, to: index)
    }

}

