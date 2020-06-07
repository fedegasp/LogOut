//
//  LogOutTests.swift
//  LogOutTests
//
//  Created by Federico Gasperini on 05/06/2020.
//  Copyright © 2020 Federico Gasperini. All rights reserved.
//

import XCTest
@testable import LogOut

class LogOutTests: XCTestCase {
    
    let readQueue = DispatchQueue.global()

    func testPipe() throws {
        var pipe: FGPipe! = FGPipe(file: STDOUT_FILENO)
        let readExpt = XCTestExpectation(description: "readPipe")
        
        XCTAssertFalse(pipe.errorPipe)
        let message: () -> String = {
            if let p = strerror(errno) {
                let len = strlen(p)
                return String(data:Data(bytes: p, count: len), encoding: .utf8) ?? "unknown"
            }
            return "unknown"
        }
        
        XCTAssertFalse(pipe.errorDup, message())
        
        readQueue.async {
            let data = pipe.read()
            if let data = data {
                let read = String(data: data, encoding: .utf8)
                XCTAssert(read?.starts(with:"test") ?? false, "----> \(read ?? "")")
            }
            else {
                XCTFail("Broken pipe")
            }
            readExpt.fulfill()
        }

        print("test")

        self.wait(for: [readExpt], timeout: 1.0)
        
        pipe = nil
        
        print("test")
    }

}
