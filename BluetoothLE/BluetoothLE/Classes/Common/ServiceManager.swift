//
//  BlutoorhFactory.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/23.
//

import Foundation

public protocol Service {
    var identifier : String { get }
}

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
    
    static private var peripheralService : PeripheralService? = nil
    
    static private var centralService : CentralService? = nil
    
    public static func sharedPeripheral() -> PeripheralService
    {
        if peripheralService == nil {
            peripheralService = PeripheralService()
        }
        
        return peripheralService!
    }
    
    public static func sharedCentral() -> CentralService
    {
        if centralService == nil {
            centralService = CentralService()
        }
        
        return centralService!
    }
}
