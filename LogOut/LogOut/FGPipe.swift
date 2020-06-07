//
//  FGPipe.swift
//  LogOut
//
//  Created by Federico Gasperini on 06/06/2020.
//  Copyright © 2020 Federico Gasperini. All rights reserved.
//

import UIKit

class FGPipe: NSObject {
    
    private var backupFD: Int32
    private var startFD: Int32
    private var pipeFiles = UnsafeMutablePointer<Int32>.allocate(capacity: 2)
    
    var errorPipe = false
    var errorDup = false
    
    init(file: Int32) {
        self.startFD = file
        self.backupFD = dup(file)
        super.init()
        if 0 == pipe(self.pipeFiles) {
            if 0 > dup2(self.pipeFiles[1], file) {
                self.errorDup = true
            }
        }
        else {
            self.errorPipe = true
        }
    }

    deinit {
        if !errorPipe {
            close(self.pipeFiles[0])
            close(self.pipeFiles[1])
            dup2(self.backupFD, self.startFD)
        }
        self.pipeFiles.deallocate()
    }
    
    func read() -> Data? {
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: 1024, alignment: 1)
        let count = LogOut.read(self.pipeFiles[0], buffer, 1024)
        var ret: Data?
        if count > 0 {
            ret = Data(bytes: buffer, count: count)
        }
        buffer.deallocate()
        return ret
    }
}
