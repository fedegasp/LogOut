//
//  PipeReader.swift
//  LogOut
//
//  Created by Federico Gasperini on 08/06/2020.
//  Copyright © 2020 Federico Gasperini. All rights reserved.
//

import Foundation

protocol PipeReaderDelegate: AnyObject {
    func pipe(reader: PipeReader, didRead: Data)
    func pipeReaderDidEnd(_ reader: PipeReader)
}

class PipeReader {
    
    private let readingQueue = DispatchQueue(label: "PipeReader")
    
    weak var delegate: PipeReaderDelegate?
    private var pipe: LogOut.Pipe?
    
    var isReading: Bool {
        return pipe != nil
    }
    
    init(fd: Int32, delegate: PipeReaderDelegate) {
        self.delegate = delegate
        self.pipe = LogOut.Pipe(file: fd)
        self.startReading()
    }
    
    func stop() {
        let pipe = self.pipe
        self.pipe = nil
        // to write a byte is needed to make the reading loop continue and fail the test
        _=pipe?.write("\0".data(using: .utf8)!)
    }
    
    deinit {
        self.stop()
    }
    
    private func startReading() {
        weak var pipe = self.pipe
        self.readingQueue.async { [weak pipe] in
            while let data = pipe?.read() {
                DispatchQueue.main.async {
                    self.delegate?.pipe(reader: self, didRead: data)
                }
            }
            self.delegate?.pipeReaderDidEnd(self)
        }
    }
}
