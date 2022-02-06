//
//  ConnectedCentral.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/02/05.
//

import Foundation
import CoreBluetooth

public class ConnectedCentral : NSObject {
    
    /// 接続している親機(セントラル)のインスタンス
    private (set) var central : CBCentral
    
    /// 親機(セントラル)のID
    public var centralId : String {
        get {
            central.identifier.uuidString
        }
    }
    
    /// コンストラクタ
    init(central: CBCentral) {
        self.central = central
        super.init()
    }
}
