//
//  ViewController.swift
//  Demo Peripheral(子機)
//
//  Created by r.nishizaki on 2022/01/22.
//

import UIKit
import BluetoothLE

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var b = ABC()
        b.MyPrint()
        var a = ABCDEF()
        a.MyPrint()
    }


}

