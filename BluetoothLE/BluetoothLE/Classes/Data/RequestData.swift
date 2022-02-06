//
//  RequestData.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/02/05.
//

import Foundation
import CoreBluetooth

public class RequestData
{
    /// サービス
    private(set) var service:CBMutableService? = nil
    
    /// キャラクタリスティック
    private(set) var characteristic:CBMutableCharacteristic? = nil
    
    /// 親機(セントラル)へ公開しているサービスID
    public var serviceId:String? { return service?.uuid.uuidString }
    
    /// 親機(セントラル)へ公開しているサービス内のデータID
    public var characteristicId:String? { return characteristic?.uuid.uuidString }
    
    /// コンストラクタ
    /// - Parameters:
    ///   - service: サービス
    ///   - characteristic: キャラクタリスティック
    init(service:CBService, characteristic:CBCharacteristic) {
        self.service = service as? CBMutableService ?? nil
        self.characteristic = characteristic as? CBMutableCharacteristic ?? nil
    }
    
    /// 受信したデータを取得する
    /// - Returns: 受信したデータ
    public func getValue() -> Data? {
        return self.characteristic?.value
    }
    
    /// 受信したデータを文字列として取得する
    /// - Returns: 受信した文字列
    public func getStringValue() -> String? {
        return self.characteristic?.getStringValue()
    }
    
    /// 受信したデータを浮動小数点として取得する
    /// - Returns: 受信した浮動小数点
    public func getDoubleValue() -> Double? {
        return self.characteristic?.getDoubleValue()
    }
    
    /// 受信したデータを整数として取得する
    /// - Returns: 受信した整数
    public func getIntValue() -> Int? {
        return self.characteristic?.getIntValue()
    }
}

// MARK: - 読み取り要求

public class ReadRequestData : RequestData
{
    /// コンストラクタ
    /// - Parameters:
    ///   - service: サービス
    ///   - characteristic: キャラクタリスティック
    override init(service:CBService, characteristic:CBCharacteristic) {
        super.init(service: service, characteristic: characteristic)
    }
}

// MARK: - 書き込み要求

public class WriteRequestData : RequestData
{
    /// 更新依頼データ
    private(set) var value:Data? = nil
    
    /// コンストラクタ
    /// - Parameters:
    ///   - service: サービス
    ///   - characteristic: キャラクタリスティック
    ///   - data: 書き込み要求データ
    init(service:CBService, characteristic:CBCharacteristic, data:Data?) {
        super.init(service: service, characteristic: characteristic)
        value = data
    }
    
    /// 受信したデータを取得する
    /// - Returns: 受信したデータ
    public override func getValue() -> Data? {
        return self.value
    }
    
    /// 受信したデータを文字列として取得する
    /// - Returns: 受信した文字列
    public override func getStringValue() -> String? {
        guard let data = self.value else { return nil }
        
        if let str = String(data: data, encoding: .utf8) {
            return str
        }
        return nil
    }
    
    /// 受信したデータを浮動小数点として取得する
    /// - Returns: 受信した浮動小数点
    public override func getDoubleValue() -> Double? {
        guard let data = self.value else { return nil }

        return data.withUnsafeBytes { $0.load( as: Double.self ) }
    }
    
    /// 受信したデータを整数として取得する
    /// - Returns: 受信した整数
    public override func getIntValue() -> Int? {
        guard let data = self.value else { return nil }

        return data.withUnsafeBytes { $0.load( as: Int.self ) }
    }
}


