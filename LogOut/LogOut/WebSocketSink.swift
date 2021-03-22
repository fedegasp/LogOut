//
//  WebSocketSink.swift
//  LogOut
//
//  Created by Federico Gasperini on 22/03/2021.
//  Copyright © 2021 Federico Gasperini. All rights reserved.
//

import Foundation
import Starscream

public class WebSocketSink: NSObject, WebSocketDelegate, LogSink {
    
    var socket: WebSocket?
    
    var host = "192.168.1.120"
    var port = "9998"
    
    private var isConnected = false
    
    public func write(data: Data) {
        guard let string = String(data: data, encoding: .utf8) else { return }
        self.socket?.write(string: string)
    }
    
    public func open() {
        if socket == nil {
            var request = URLRequest(url: URL(string: "wss://\(host):\(port)")!)
            request.timeoutInterval = 5
            let pinner = FoundationSecurity(allowSelfSigned: true) // don't validate SSL certificates
            socket = WebSocket(request: request, certPinner: pinner)
            socket?.delegate = self
        }
        if !isConnected {
            socket?.connect()
        }
    }
    
    public func close() {
        socket?.disconnect()
    }
    
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handle(error)
        }
    }
    
    private func handle(_ error: Error?) {
        
    }
}
