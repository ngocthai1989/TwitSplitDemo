//
//  TwitSplitTests.swift
//  TwitSplitTests
//
//  Created by Thien Huynh on 3/31/18.
//  Copyright © 2018 Thien Huynh. All rights reserved.
//

import XCTest
@testable import TwitSplit

class TwitSplitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // input example message
    func testExampleMessage() {
        let input = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expected = ["1/2 I can't believe Tweeter now supports chunking",
                        "2/2 my messages, so I don't have to do it myself."]
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
    }
    
    // input message length less than limit character
    func testMessageLessThanLimit() {
        let input = "I can't believe Tweeter now supports chunking mes"
        let expected = ["I can't believe Tweeter now supports chunking mes"]
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
    }
    
    // input message length reach the limit character
    func testMessageReachLimit() {
        let input = "I can't believe Tweeter now supports chunking mess"
        let expected = ["I can't believe Tweeter now supports chunking mess"]
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
    }
    
    // input message with a span of non-whitespace characters longer than the limit character
    func testInvalidSpanOfNonWhitespace() {
        let input = "Ican'tbelieveTweeternowsupportschunkingmymessages,soIdon'thavetodoitmyself."
        let expected = [String]()
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
    }
    
    // input message is empty
    func testEmptyMessage() {
        let input = ""
        let expected = [""]
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
        
    }
    
    // input message contains a span of non-whitespace characters longer than the limit character after a valid word
    func testInvalidSpanOfNonWhitespaceAfterAValidWord() {
        let input = "I can't believeTweeternowsupportschunkingmymessages,soIdon'thavetodoitmyself."
        let expected = [String]()
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
    }
    
    // input message will split more than 10 chunks
    func testMoreThanTenChunks() {
        let input = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expected = ["1/11 I can't believe Tweeter now supports chunking",
                        "2/11 my messages, so I don't have to do it",
                        "3/11 myself.I can't believe Tweeter now supports",
                        "4/11 chunking my messages, so I don't have to do",
                        "5/11 it myself.I can't believe Tweeter now",
                        "6/11 supports chunking my messages, so I don't",
                        "7/11 have to do it myself.I can't believe Tweeter",
                        "8/11 now supports chunking my messages, so I don't",
                        "9/11 have to do it myself.I can't believe Tweeter",
                        "10/11 now supports chunking my messages, so I don't",
                        "11/11 have to do it myself."]
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
    }
    
    // input message with a span of whitespace characters longer than the limit character
    func testLongWhitepspace() {
        let input = "I can't believe Tweeter now               \n \t                      supports chunking my messages, so I don't have to do it myself."
        let expected = ["1/3 I can't believe Tweeter now",
                        "2/3 supports chunking my messages, so I don't have",
                        "3/3 to do it myself."]
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
    }
    
    // input message with a span of whitespace characters which can split into a chunk
    func testASpanOfWhitepspaceInAChunk() {
        let input = "I can't                \n               believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expected = ["1/3 I can't                \n               believe",
                        "2/3 Tweeter now supports chunking my messages, so",
                        "3/3 I don't have to do it myself."]
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
    }
    
    // input message with a span of whitespace characters at the split position
    func testSplitAtASpanOfWhitepspace() {
        let input = "I can't believe Tweeter now supports chunking   \n        my messages, so I don't have to do it myself."
        let expected = ["1/2 I can't believe Tweeter now supports chunking",
                        "2/2 my messages, so I don't have to do it myself."]
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
    }
    
    // input message end with a span of whitespace characters
    func testEndWithASpanOfWhitepspaces() {
        let input = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. I can't believe Tweeter now supports chunking         \n          "
        let expected = ["1/3 I can't believe Tweeter now supports chunking",
                        "2/3 my messages, so I don't have to do it myself.",
                        "3/3 I can't believe Tweeter now supports chunking"]
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
    }
    
    // input message start with a span of whitespace characters
    func testStartWithASpanOfWhitepspaces() {
        let input = "            I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expected = ["1/2 I can't believe Tweeter now supports chunking",
                        "2/2 my messages, so I don't have to do it myself."]
        
        let output = Util.splitMessage(input)
        
        XCTAssertEqual(output, expected)
    }
    
}
