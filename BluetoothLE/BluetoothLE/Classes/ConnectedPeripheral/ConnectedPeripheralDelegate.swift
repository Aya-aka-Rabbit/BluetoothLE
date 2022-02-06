//
//  ConnectedPeripheralDelegate.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/30.
//

import Foundation

// MARK: - 必須プロトコル
public protocol ConnectedPeripheralDelegate : ConnectedPeripheralOptionalDelegate {
    
    /// 子機(ペリフェラル)の公開しているサービスを検出した際の通知
    /// - Parameters:
    ///   - connectedPeripheral: 接続した子機(ペリフェラル)オブジェクト
    ///   - services: 公開しているサービスUUIDの一覧
    ///   - error: エラー情報
    func didDiscoverServices(_ connectedPeripheral:ConnectedPeripheral, services:[String], error: Error?)
    
    /// 子機(ペリフェラル)の公開しているサービス内のデータを検出した際の通知
    /// - Parameters:
    ///   - connectedPeripheral: 接続した子機(ペリフェラル)オブジェクト
    ///   - Characteristics: サービス内のデータUUID一覧
    ///   - error: エラー情報
    func didDiscoverCharacteristics(_ connectedPeripheral:ConnectedPeripheral, characteristics:[String], error: Error?)
    
    /// 子機(ペリフェラル)からリクエストに対するレスポンスを検出した際の通知
    /// - Parameters:
    ///   - connectedPeripheral: 接続した子機(ペリフェラル)オブジェクト
    ///   - response: レスポンスデータ
    ///   - error: エラー情報
    func didReceivedResponseFrom(_ connectedPeripheral:ConnectedPeripheral, response:ResponseData, error: Error?)
}

// MARK: - ConnectedPeripheralOptionalDelegateオプショナルプロトコル
public protocol ConnectedPeripheralOptionalDelegate {
    

}

public extension ConnectedPeripheralDelegate {
 
}

