//
//  PeripheralServiceBuilder.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/30.
//

import Foundation
import CoreBluetooth

/// 子機(ペリフェラル)のサービスを作成するためのビルダークラス
public class PeripheralServiceBuilder {
    
    /// サービス
    private (set) var service : CBMutableService? = nil
    
    /// コンストラクタ
    /// - Parameter serviceId: UUIDの文字列
    /// - Remark: BLEで用いるサービス用のUUIDは以下の方法で作成
    ///
    /// -- ターミナルでuuidgenを入力した文字列
    ///
    /// -- UUID().uuidStringで作成
    public init (serviceId: String) {
        if serviceId.isEmpty { return }
        let uuid = CBUUID(string: serviceId)
       
        //サービス,キャラクタリスティックの追加
        service = CBMutableService(type: uuid, primary: true)
    }
}

// MARK: - 外部公開

/// 子機(ペリフェラル)のサービスを作成するためのビルダークラス
extension PeripheralServiceBuilder {
    
    /// アドバタイズのサービスに公開する書き込み専用のデータを追加する
    /// - Parameters:
    ///   - code: データを識別するUUIDの文字列
    /// - Returns: true:成功 false:失敗
    /// - Remark: BLEで用いるサービス用のUUIDは以下の方法で作成
    ///
    /// -- ターミナルでuuidgenを入力した文字列
    ///
    /// -- UUID().uuidStringで作成
    public func appendWriteCharacteristic(code: String) -> Bool {
        
        guard let _ = service else { return false }
        if let list = service!.characteristics {
            if list.contains(where: {
                $0.uuid.uuidString.caseInsensitiveCompare(code) == .orderedSame
            }) { return false }
        }
        
        let properties: CBCharacteristicProperties = [.write]
        let permissions: CBAttributePermissions = [.writeable]
        let characteristic = CBMutableCharacteristic(type: CBUUID(string: code),
                                                 properties: properties,
                                                 value: nil,
                                                 permissions: permissions)
        if var list = service!.characteristics {
            list.append(characteristic)
            service!.characteristics = list
        }
        else {
            service!.characteristics = [characteristic]
        }
        
        return true
    }
    
    /// アドバタイズのサービスに公開する読み取りと書き込み両用のデータを追加する
    /// - Parameters:
    ///   - code: データを識別するUUIDの文字列
    /// - Returns: true:成功 false:失敗
    /// - Remark: BLEで用いるサービス用のUUIDは以下の方法で作成
    ///
    /// -- ターミナルでuuidgenを入力した文字列
    ///
    /// -- UUID().uuidStringで作成
    public func appendCharacteristic(code: String) -> Bool {
        
        guard let _ = service else { return false }
        if let list = service!.characteristics {
            if list.contains(where: {
                $0.uuid.uuidString.caseInsensitiveCompare(code) == .orderedSame
            }) { return false }
        }
        
        let properties: CBCharacteristicProperties = [.write, .read]
        let permissions: CBAttributePermissions = [.writeable, .readable]
        let characteristic = CBMutableCharacteristic(type: CBUUID(string: code),
                                                 properties: properties,
                                                 value: nil,
                                                 permissions: permissions)
        if var list = service!.characteristics {
            list.append(characteristic)
            service!.characteristics = list
        }
        else {
            service!.characteristics = [characteristic]
        }
        
        return true
    }
    
    /// アドバタイズのサービスに公開する読み取り専用のデータを追加する
    /// - Parameters:
    ///   - code: データを識別するUUIDの文字列
    /// - Returns: true:成功 false:失敗
    /// - Remark: BLEで用いるサービス用のUUIDは以下の方法で作成
    ///
    /// -- ターミナルでuuidgenを入力した文字列
    ///
    /// -- UUID().uuidStringで作成
    public func appendReadCharacteristic(code: String) -> Bool {
        
        guard let _ = service else { return false }
        if let list = service!.characteristics {
            if list.contains(where: {
                $0.uuid.uuidString.caseInsensitiveCompare(code) == .orderedSame
            }) { return false }
        }
        
        let properties: CBCharacteristicProperties = [.read]
        let permissions: CBAttributePermissions = [.readable]
        let characteristic = CBMutableCharacteristic(type: CBUUID(string: code),
                                                 properties: properties,
                                                 value: nil,
                                                 permissions: permissions)
        if var list = service!.characteristics {
            list.append(characteristic)
            service!.characteristics = list
        }
        else {
            service!.characteristics = [characteristic]
        }
        
        return true
    }
}
