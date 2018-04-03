//
//  Util.swift
//  TwitSplit
//
//  Created by Thien Huynh on 3/31/18.
//  Copyright © 2018 Thien Huynh. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    private typealias Chunk = (start: Int, length: Int)
    static let LIMIT_CHARACTER = 20
    
    static func splitMessage(_ message: String) -> [String] {
       
        // VARIABLES
        var start = 0
        var lengthOfTotalChunks = 1
        var chunks = [Chunk]()
        
        // SUB FUNCTIONS
        /// find left closest position of whitespace character from specific position
        func findLeftWhitespace(from position: Int) -> Int {
            
            // validate position
            guard position >= 0 && position < message.count else {
                return 0
            }
            
            // get reversed string of input message
            let reverseStr = String(message[...position].reversed())
            
            // get range of whitespace character
            if let range = reverseStr.range(of: "\\s", options: .regularExpression) {
                // return found position
                let found = message.distance(from: reverseStr.startIndex, to: range.lowerBound)
                return position - found
            }
            
            return 0
        }
        
        /// find right closest position of non-whitespace character from specific position
        func findRightCharacter(from position: Int) -> Int? {
            
            // validate position
            guard position >= 0 && position < message.count else {
                return nil
            }
            
            // get range of non-whitespace character
            if let range = message[position...].range(of: "\\S", options: .regularExpression) {
                // return found position
                let posFound = message.distance(from: message.index(message.startIndex, offsetBy:position), to: range.lowerBound)
                return posFound + position
            }
            
            return nil
        }
        
        /// split message to new chunk
        func splitChunk() -> Chunk? {
            
            // length of the part indicator = the index of new chunk + "/" + length of total Chunks + " "
            let partIndicatorLength = chunks.count.numOfCharacters + 2 + lengthOfTotalChunks
            
            // estimate the length of new chunk
            let estimateLength = LIMIT_CHARACTER - partIndicatorLength
            
            // calculate the position to split
            var splitPosition = 0
            let estimatePosision = start + estimateLength
            if estimatePosision >= message.count {
                // if estimatePosision is greater or equal the message length
                // then the splitPosition will be the end index of message
                splitPosition = message.count - 1
                
            } else {
                // else find the left closest whitespace from the estimateposition
                splitPosition = findLeftWhitespace(from: estimatePosision) - 1
            }
            
            // calculate length of new chunk
            let length = splitPosition - start + 1
            
            // validate the length of chunk
            if length <= 0 {
                return nil
            }
            
            // return new chunk
            return (start, length)
        }
        
        /// re-validate current chunks when lengthOfTotalChunks changes value
        func reSplit() {
            
            // prepare new array
            var newChunks = [Chunk]()
            
            // reset start
            start = 0
            
            // check each chunk
            for (index, item) in chunks.enumerated() {
                
                // calculate new partIndicatorLength and estimateLength
                let partIndicatorLength = index.numOfCharacters + 2 + lengthOfTotalChunks
                let estimateLength = LIMIT_CHARACTER - partIndicatorLength
                
                // if estimateLength is valid
                if estimateLength >= item.length {
                    // append to new array
                    newChunks.append(item)
                    // calculate next start
                    start = item.start + item.length
                    
                } else {
                    // if estimateLength is invalid then remove the rest chunks in old array
                    chunks = newChunks
                    break
                    
                }
            }
            
        }
        
        /// making the result array of strings
        func toArrayString() -> [String] {
            
            // result array
            var lstString = [String]()
            
            for (index, item) in chunks.enumerated() {
                // get sub string from start & length values of chunk
                let splitStr = String(message[item.start...(item.start + item.length - 1)]).trimmingCharacters(in: .whitespacesAndNewlines)
                
                // make complete message
                let str = "\(index + 1)/\(chunks.count) " + splitStr
                
                // append new message to result array
                lstString.append(str)
            }
            
            return lstString
        }
        
        // MAIN FUNCTION
        
        // if message length is valid
        if message.count <= LIMIT_CHARACTER {
            return [message]
        }
        
        // if message doesn't have whitespace character
        if message.range(of: "\\s", options: .regularExpression) == nil {
            return []
        }
        
        // while loop to split chunk
        while start < message.count {
            // get new chunk
            guard let newChunk = splitChunk() else {
                // if can't split cause by a span of non-whitespace characters longer than the limit character
                chunks.removeAll()
                break
            }
            
            // append new chunk
            chunks.append(newChunk)
            
            // find right closest non-whitespace character
            if let newStart = findRightCharacter(from: newChunk.start + newChunk.length) {
                
                // check if lengthOfTotalChunks would be changed
                if (chunks.count + 1).numOfCharacters > lengthOfTotalChunks {
                    
                    // set the new lengthOfTotalChunks
                    lengthOfTotalChunks = (chunks.count + 1).numOfCharacters
                    
                    // re-split to get new chunks array and new start position for continued looping
                    reSplit()
                    
                } else {
                    // set the new start position
                    start = newStart
                }
                
            } else {
                // if there is nothing to continue split
                break
            }
        }
        
        // return array of strings result
        return toArrayString()
    }
}
