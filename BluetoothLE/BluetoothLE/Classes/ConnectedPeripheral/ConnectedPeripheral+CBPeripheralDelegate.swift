//
//  ConnectedPeripheral+CBPeripheralDelegate.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/30.
//

import Foundation
import CoreBluetooth

extension ConnectedPeripheral : CBPeripheralDelegate {
    
    /// サービスの検出が成功した場合に呼び出される
    /// - Parameters:
    ///   - peripheral: 子機(ペリフェラル)
    ///   - error: エラー情報
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        guard let list = try? getServices() else { return }
        delegate?.didDiscoverServices(self, services: list, error: error)
    }
    
    /// サービスの特性を検出した場合に呼び出される
    /// - Parameters:
    ///   - peripheral: 子機(ペリフェラル)
    ///   - service: サービス
    ///   - error: エラー情報
    public func peripheral(_ peripheral: CBPeripheral,
                           didDiscoverCharacteristicsFor service: CBService,
                           error: Error?) {
        guard let list = try? getCharacteristics(id: service.uuid.uuidString) else { return }
        delegate?.didDiscoverCharacteristics(self, characteristics: list, error: error)
    }
    
    /// 指定されたキャラクタリスティックの値の取得が成功した際に呼び出される
    /// - Parameters:
    ///   - peripheral: 子機(ペリフェラル)
    ///   - characteristic: キャラクタリスティック
    ///   - error: エラー情報
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        // レスポンスデータの作成s
        guard let service = characteristic.service else { return }
        let data = ResponseData(service: service, characteristic: characteristic)
        delegate?.didReceivedResponseFrom(self, response: data, error: error)
    }
}


