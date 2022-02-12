//
//  BluetoothLEServiceProtocol.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/02/12.
//

import Foundation

/// BluetoothLEサービスI/Fクラス
public protocol BluetoothLEServiceProtocol {
    
    /// BluetoothLEサービスの識別子
    var identifier : String { get }
}
