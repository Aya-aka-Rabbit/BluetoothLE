//
//  CBCharacteristic+Common.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/02/06.
//

import Foundation
import CoreBluetooth

extension CBCharacteristic {
    
    /// 受信したデータを文字列として取得する
    /// - Returns: 受信した文字列
    public func getStringValue() -> String? {
        guard let data = self.value else { return nil }
        
        if let str = String(data: data, encoding: .utf8) {
            return str
        }
        return nil
    }
    
    /// 受信したデータを浮動小数点として取得する
    /// - Returns: 受信した浮動小数点
    public func getDoubleValue() -> Double? {
        guard let data = self.value else { return nil }

        return data.withUnsafeBytes { $0.load( as: Double.self ) }
    }
    
    /// 受信したデータを整数として取得する
    /// - Returns: 受信した整数
    public func getIntValue() -> Int? {
        guard let data = self.value else { return nil }

        return data.withUnsafeBytes { $0.load( as: Int.self ) }
    }
}
