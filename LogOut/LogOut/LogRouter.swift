//
//  LogRouter.swift
//  LogOut
//
//  Created by Federico Gasperini on 22/03/2021.
//  Copyright © 2021 Federico Gasperini. All rights reserved.
//

import UIKit

@objc public protocol LogSink {
    func write(data: Data)
    func open()
    func close()
}

public class LogRouter: NSObject, PipeReaderDelegate {
    
    var reader: PipeReader?
    @objc public var logSink: LogSink?
    
    @objc public func start(on fd: Int32) {
        logSink?.open()
        reader = PipeReader(fd: fd, delegate: self)
    }
    
    @objc public func stop() {
        reader = nil
    }
    
    func pipe(reader: PipeReader, didRead data: Data) {
        logSink?.write(data: data)
    }
    
    func pipeReaderDidEnd(_ reader: PipeReader) {
        self.reader = nil
    }
    
    deinit {
        reader = nil
    }
}
