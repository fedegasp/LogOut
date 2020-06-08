//
//  LogOutTests.swift
//  LogOutTests
//
//  Created by Federico Gasperini on 05/06/2020.
//  Copyright © 2020 Federico Gasperini. All rights reserved.
//

import XCTest
@testable import LogOut

class LogOutTests: XCTestCase, PipeReaderDelegate {
    
    let readQueue = DispatchQueue.global()

    func testPipe() throws {
        var pipe: LogOut.Pipe! = Pipe(file: STDOUT_FILENO)
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

    
    var expectation: XCTestExpectation?
    func testPipeReader() throws {
        let pipeReader = PipeReader(fd: STDOUT_FILENO, delegate: self)
        self.expectation = XCTestExpectation(description: "pipeReader")
        pipeReader.stop()
        wait(for: [self.expectation!], timeout: 1.0)
    }
    
    func pipe(reader: PipeReader, didRead: Data) {
        
    }
    
    func pipeReaderDidEnd(_ reader: PipeReader) {
        self.expectation?.fulfill()
    }
}
