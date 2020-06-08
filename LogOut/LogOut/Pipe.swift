//
//  Pipe.swift
//  LogOut
//
//  Created by Federico Gasperini on 06/06/2020.
//  Copyright © 2020 Federico Gasperini. All rights reserved.
//

import UIKit

class Pipe {
    
    private var backupFD: Int32
    private var startFD: Int32
    private var pipeFiles = UnsafeMutablePointer<Int32>.allocate(capacity: 2)
    
    var errorPipe = false
    var errorDup = false
    
    var split = false
    
    init(file: Int32) {
        self.startFD = file
        self.backupFD = dup(file)
        if self.backupFD > 0 {
            if 0 == pipe(self.pipeFiles) {
                if 0 > dup2(self.pipeFiles[1], file) {
                    Logger.log("Cannot redirect \(file) onto writing pipe end")
                    self.errorDup = true
                }
            }
            else {
                Logger.log("Cannot create pipe")
                self.errorPipe = true
            }
        }
        else {
            Logger.log("Cannot create backup of \(file) fd number")
        }
    }

    deinit {
        if !errorPipe {
            close(self.pipeFiles[0])
            close(self.pipeFiles[1])
            if !errorDup,
                self.backupFD > 0 {
                dup2(self.backupFD, self.startFD)
                close(self.backupFD)
            }
        }
        self.pipeFiles.deallocate()
    }
    
    func read() -> Data? {
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: 1024, alignment: 1)
        let count = LogOut.read(self.pipeFiles[0], buffer, 1024)
        var ret: Data? = nil
        if count > 0 {
            if split {
                LogOut.write(self.backupFD, buffer, count)
            }
            ret = Data(bytes: buffer, count: count)
        }
        buffer.deallocate()
        return ret
    }
    
    func write(_ data: Data) -> Int {
        return data.withUnsafeBytes { (buffer) -> Int in
            let unsafeBufferPtr = buffer.bindMemory(to: UInt8.self)
            if let unsafePtr = unsafeBufferPtr.baseAddress {
                return LogOut.write(self.pipeFiles[1], unsafePtr, data.count)
            }
            return 0
        }
    }
}
