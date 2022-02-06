//
//  PeripheralServiceDelegate.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/23.
//

import Foundation

// MARK: - 必須プロトコル
public protocol PeripheralServiceDelegate : BluetoothLEStateDelegate, PeripheralServiceOptionalDelegate {
    
    /// 親機(セントラル)と通信する際のアドバタイズの名前を取得する
    /// - Returns: アドバタイズの名前
    func advertisementLocalName() -> String
    
    /// 親機(セントラル)から要求を受信した際の通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - request: 要求データ
    /// - Returns: 要求に対する応答コード
    func didReceiveRequest(central:ConnectedCentral, request:RequestData) -> ResponseCode
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

// MARK: - PeripheralServiceOptionalDelegateオプショナルプロトコル
public protocol PeripheralServiceOptionalDelegate {
    
    /// 親機(セントラル)とのアドバタイズを開始したことの通知
    /// - Parameters:
    ///   - error: エラー情報
    func didStartAdvertising(error: Error?)
    
    /// 親機(セントラル)がサブスクライブしたことの通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - id: サブスクライブしたアドバタイズのサービス公開データを識別するUUIDの文字列
    func didSubscribeTo(central:ConnectedCentral, id:String)
    
    /// 親機(セントラル)がサブスクライブを解除したことの通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - id: 解除したアドバタイズのサービス公開データを識別するUUIDの文字列
    func didUnsubscribeFrom(central:ConnectedCentral, id:String)
    
    /// 親機(セントラル)から書込要求を受信した際に書込データを要求する通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - request: 書き込み要求データ
    /// - Returns: 親機(セントラル)に公開しているデータに対して書き込む最新データ
    func AcquireWriteDataByWriteRequestFrom(central:ConnectedCentral, request:WriteRequestData) -> Data?

    /// 親機(セントラル)から読取要求を受信した際の通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - request: 読み取り要求データ
    /// - Returns: 親機(セントラル)に公開しているデータに対して返却する最新データ
    func AcquireReadDataByReadRequestFrom(central:ConnectedCentral, request:ReadRequestData) -> Data?
}

public extension PeripheralServiceDelegate {
    
    /// 親機(セントラル)とのアドバタイズを開始したことの通知
    /// - Parameters:
    ///   - error: エラー情報
    func didStartAdvertising(error: Error?) {}
    
    /// 親機(セントラル)がサブスクライブしたことの通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - id: サブスクライブしたアドバタイズのサービス公開データを識別するUUIDの文字列
    func didSubscribeTo(central:ConnectedCentral, id:String) {}
    
    /// 親機(セントラル)がサブスクライブを解除したことの通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - id: 解除したアドバタイズのサービス公開データを識別するUUIDの文字列
    func didUnsubscribeFrom(central:ConnectedCentral, id:String) {}
    
    /// 親機(セントラル)から書込要求を受信した際に書込データを要求する通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - request: 書き込み要求データ
    /// - Returns: 親機(セントラル)に公開しているデータに対して書き込む最新データ
    func AcquireWriteDataByWriteRequestFrom(central:ConnectedCentral, request:WriteRequestData) -> Data? { return nil }

    /// 親機(セントラル)から読取要求を受信した際の通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - request: 読み取り要求データ
    /// - Returns: 親機(セントラル)に公開しているデータに対して返却する最新データ
    func AcquireReadDataByReadRequestFrom(central:ConnectedCentral, request:ReadRequestData) -> Data? { return nil }
}
