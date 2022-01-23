//
//  PeripheralService+PeripheralManagerDelegate.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/23.
//

import Foundation
import CoreBluetooth

extension PeripheralService : CBPeripheralManagerDelegate {
    
    /// 周辺機器マネージャーの状態が更新されるたびに呼び出される
    /// - Parameter peripheral: マネージャ
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            delegate?.bluetoothPoweredOn()
        case .unknown:
            delegate?.bluetoothServiceError()
        case .resetting:
            delegate?.bluetoothResetting()
        case .unsupported:
            delegate?.bluetoothUnsupported()
        case .unauthorized:
            delegate?.bluetoothUnauthorized()
        case .poweredOff:
            delegate?.bluetoothPoweredOff()
        @unknown default:
            delegate?.bluetoothServiceError()
        }
    }
}
