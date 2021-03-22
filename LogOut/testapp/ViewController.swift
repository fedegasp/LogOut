//
//  ViewController.swift
//  testapp
//
//  Created by Federico Gasperini on 19/03/2021.
//  Copyright © 2021 Federico Gasperini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        NSLog("Ciao")
    }

}
