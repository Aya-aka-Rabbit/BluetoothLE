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
    
    static var peripheralService : PeripheralService? = nil
    
    static var centralService : CentralService? = nil
    
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
