//
//  CentralServiceDelegate.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/28.
//

import Foundation

// MARK: - 必須プロトコル
public protocol CentralServiceDelegate : BluetoothLEStateDelegate, CentralServiceOptionalDelegate {
    
    /// 親機(セントラル)がスキャン中に子機(ペリフェラル)を検出した際の通知
    /// - Parameters:
    ///   - data: 子機(ペリフェラル)の情報
    ///   - connectable: 子機(ペリフェラル)が接続可能であるかどうか
    func didDiscoveredPeripheral(information data:DiscoveryPeripheralData, isConnectable connectable:Bool)
}

// MARK: - BluetoothLEStateDelegateオプショナルプロトコル
public extension CentralServiceDelegate {
    
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

// MARK: - CentralServiceOptionalDelegateオプショナルプロトコル
public protocol CentralServiceOptionalDelegate {
    
    /// 親機(セントラル)が子機(ペリフェラル)に接続した際の通知
    /// - Parameters:
    ///   - peripheralId: 接続した子機(ペリフェラル)のID
    ///   - error: 失敗した際のエラー情報
    func didPeripheralConnect(peripheralId:String, error: Error?)
    
    /// 親機(セントラル)が子機(ペリフェラル)との接続に切断した際の通知
    /// - Parameters:
    ///   - peripheralId: 切断した子機(ペリフェラル)のID
    ///   - error: 失敗した際のエラー情報
    func didPeripheralDisconnect(peripheralId:String, error: Error?)
}

public extension CentralServiceDelegate {

    /// 親機(セントラル)が子機(ペリフェラル)に接続した際の通知
    /// - Parameters:
    ///   - peripheralId: 接続した子機(ペリフェラル)のID
    ///   - error: 失敗した際のエラー情報
    func didPeripheralConnect(peripheralId:String, error: Error?) {}
    
    /// 親機(セントラル)が子機(ペリフェラル)との接続に切断した際の通知
    /// - Parameters:
    ///   - peripheralId: 切断した子機(ペリフェラル)のID
    ///   - error: 失敗した際のエラー情報
    func didPeripheralDisconnect(peripheralId:String, error: Error?) {}
}
