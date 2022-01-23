//
//  BluetoothLEStateDelegate.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/23.
//

import Foundation

public protocol BluetoothLEStateDelegate {
    
    /// Bluetoothの電源が現在オンになった通知
    func bluetoothPoweredOn()
   
    /// Bluetoothの電源が現在オフになった通知
    func bluetoothPoweredOff()
    
    /// Bluetoothシステムサービスとの接続が一時的に失われた通知
    func bluetoothResetting()
    
    /// BluetoothLowEnergyの使用が許可されていない通知
    func bluetoothUnauthorized()
    
    /// BluetoothLowEnergyがサポートされていない通知
    func bluetoothUnsupported()
    
    /// BluetoothLowEnergyのエラー通知
    func bluetoothServiceError()
}
