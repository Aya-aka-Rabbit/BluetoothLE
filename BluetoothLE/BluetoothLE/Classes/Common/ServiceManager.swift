//
//  BlutoorhFactory.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/23.
//

import Foundation

/// BluetoothLE サービスを管理するマネージャクラス
final public class ServiceManager {
    
    /// バッテリ情報サービスのUUID
    /// - Note: https://btprodspecificationrefs.blob.core.windows.net/assigned-values/16-bit%20UUID%20Numbers%20Document.pdf
    static let batteryAppleServiceUUID : String = "180F"
    
    /// 現在日時情報サービスのUUID
    /// - Note: https://btprodspecificationrefs.blob.core.windows.net/assigned-values/16-bit%20UUID%20Numbers%20Document.pdf
    static let currentTimeAppleServiceUUID : String = "1805"
    
    /// デバイス情報サービスのUUID
    /// - Note: https://btprodspecificationrefs.blob.core.windows.net/assigned-values/16-bit%20UUID%20Numbers%20Document.pdf
    static let deviceInformationAppleServiceUUID : String = "180A"
    
    /// 子機(ペリフェラル)のサービスオブジェクト
    static private var peripheralService : PeripheralService? = nil
    
    /// 親機(セントラル)のサービスオブジェクト
    static private var centralService : CentralService? = nil
}

// MARK: - 外部公開

/// BluetoothLE サービスを管理するマネージャクラス
extension ServiceManager {
    
    /// 子機(ペリフェラル)のサービスオブジェクトを作成する
    /// - Returns: 子機(ペリフェラル)のサービスオブジェクト
    public static func sharedPeripheral() -> PeripheralService
    {
        if peripheralService == nil {
            peripheralService = PeripheralService()
        }
        
        return peripheralService!
    }
    
    /// 親機(セントラル)のサービスオブジェクトを作成する
    /// - Returns: 親機(セントラル)のサービスオブジェクト
    public static func sharedCentral() -> CentralService
    {
        if centralService == nil {
            centralService = CentralService()
        }
        
        return centralService!
    }
}
