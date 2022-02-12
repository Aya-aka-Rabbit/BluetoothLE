//
//  ResponseData.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/02/06.
//

import Foundation
import CoreBluetooth

/// 子機(ペリフェラル)からの応答データ
public class ResponseData
{
    /// サービス
    private(set) var service:CBService? = nil
    
    /// キャラクタリスティック
    private(set) var characteristic:CBCharacteristic? = nil
    
    /// 子機(ペリフェラル)が公開しているサービスID
    public var serviceId:String? { return service?.uuid.uuidString }
    
    /// 子機(ペリフェラル)が公開しているサービス内のデータID
    public var characteristicId:String? { return characteristic?.uuid.uuidString }
    
    /// コンストラクタ
    /// - Parameters:
    ///   - service: サービス
    ///   - characteristic: キャラクタリスティック
    init(service:CBService, characteristic:CBCharacteristic) {
        self.service = service
        self.characteristic = characteristic
    }
    
    /// 受信したデータを取得する
    /// - Returns: 受信したデータ
    public func getValue() -> Data? {
        return self.characteristic?.value
    }
    
    /// 受信したデータを文字列として取得する
    /// - Returns: 受信した文字列データ
    public func getStringValue() -> String? {
        return self.characteristic?.getStringValue()
    }
    
    /// 受信したデータを浮動小数点として取得する
    /// - Returns: 受信した浮動小数点データ
    public func getDoubleValue() -> Double? {
        return self.characteristic?.getDoubleValue()
    }
    
    /// 受信したデータを整数として取得する
    /// - Returns: 受信した整数データ
    public func getIntValue() -> Int? {
        return self.characteristic?.getIntValue()
    }
}
