//
//  PeripheralServiceDelegate.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/23.
//

import Foundation

// MARK: - 必須プロトコル
public protocol PeripheralServiceDelegate : BluetoothLEStateDelegate {
    
    /// セントラルと通信する際のアドバタイズの名前を取得する
    /// - Returns: アドバタイズの名前
    func advertisementLocalName() -> String
}

// MARK: - BluetoothLEStateDelegateオプショナルプロトコル
public extension PeripheralServiceDelegate {
    
    /// Bluetoothの電源が現在オンになった通知
    func bluetoothPoweredOn() {}
   
    /// Bluetoothの電源が現在オフになった通知
    func bluetoothPoweredOff() {}
    
    /// Bluetoothシステムサービスとの接続が一時的に失われた通知
    func bluetoothResetting() {}
    
    /// BluetoothLowEnergyの使用が許可されていない通知
    func bluetoothUnauthorized() {}
    
    /// BluetoothLowEnergyがサポートされていない通知
    func bluetoothUnsupported() {}
    
    /// BluetoothLowEnergyのエラー通知
    func bluetoothServiceError() {}
}
