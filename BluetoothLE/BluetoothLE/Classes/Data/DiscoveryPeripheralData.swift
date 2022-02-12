//
//  DiscoveryPeripheralData.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/28.
//

import Foundation
import CoreBluetooth

/// 子機(ペリフェラル)検出時の情報
public struct DiscoveryPeripheralData {
    
    /// 子機(ペリフェラル)のインスタンス
    let peripheral: CBPeripheral?
    
    /// 子機(ペリフェラル)のアドバタイズの名前
    public var advertisementName : String? = nil
 
    /// 子機(ペリフェラル)の名前
    public var name : String? = nil
    
    /// 検出時間
    public var discoveryTime : Date? = nil
    
    /// 通信強度( 0 に近いほど電波が強い)
    public var rssi : Int? = nil
    
    /// 子機(ペリフェラル)のID
    public var peripheralId : String? {
        get {
            peripheral?.identifier.uuidString
        }
    }
    
    /// コンストラクタ
    /// - Parameter peripheral: 子機(ペリフェラル)
    init(_ peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
}
