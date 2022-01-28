//
//  CentralerviceDelegate.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/28.
//

import Foundation

public protocol CentralerviceOptionalDelegate {
    
    /// 親機(セントラル)がスキャン中に子機(ペリフェラル)を検出した際の通知
    /// - Parameters:
    ///   - data: 子機(ペリフェラル)の情報
    ///   - connectable: 子機(ペリフェラル)が接続可能であるかどうか
    func didDiscoveredPeripheral(information data:DiscoveryPeripheralData, isConnectable connectable:Bool)
    
    /// スキャン中に定期的にスキャンを停止するかどうかを尋ねる通知
    /// - Parameters:
    /// - Returns: true:停止する false:停止しない
    func doWantToStopScanning() -> Bool
}

// MARK: - 必須プロトコル
public protocol CentralerviceDelegate : BluetoothLEStateDelegate, CentralerviceOptionalDelegate {
    
    /// 親機(セントラル)がスキャン中に検出した子機(ペリフェラル)に接続するかどうか
    /// - Parameters:
    ///   - data: 子機(ペリフェラル)の情報
    /// - Returns: true:接続する false:接続しない
    func doWantToConnect(information data:DiscoveryPeripheralData) -> Bool
}

// MARK: - BluetoothLEStateDelegateオプショナルプロトコル
public extension CentralerviceDelegate {
    
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

// MARK: - CentralerviceOptionalDelegateオプショナルプロトコル
public extension CentralerviceDelegate {
    
    /// 親機(セントラル)がスキャン中に子機(ペリフェラル)を検出した際の通知
    /// - Parameters:
    ///   - data: 子機(ペリフェラル)の情報
    ///   - connectable: 子機(ペリフェラル)が接続可能であるかどうか
    func didDiscoveredPeripheral(information data:DiscoveryPeripheralData, isConnectable connectable:Bool) {}
    
    /// スキャン中に定期的にスキャンを停止するかどうかを尋ねる通知
    /// - Parameters:
    /// - Returns: true:停止する false:停止しない
    func doWantToStopScanning() -> Bool { return false }
}
