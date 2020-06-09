//
//  Logger.swift
//  LogOut
//
//  Created by Federico Gasperini on 08/06/2020.
//  Copyright © 2020 Federico Gasperini. All rights reserved.
//

import Foundation
import os

struct Logger {
    static let fg = OSLog(subsystem: String(describing: Self()), category: "INFO")
    static func log(_ string: String) {
        os_log("%@", log: Logger.fg, type: .info, string)
    }
}

// exposing the struct through a class
@objc(LOLogger)
public class OBJLogger: NSObject {
    @objc public static func log(_ string: String) {
        Logger.log(string)
    }
}
