//
//  CentralService+CentralManagerDelegate.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/28.
//

import Foundation
import CoreBluetooth

extension CentralService : CBCentralManagerDelegate {
    
    /// 中央マネージャーの状態が更新されるたびに呼び出される
    /// - Parameter central: マネージャ
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
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
    
    /// 親機(セントラル)がスキャン中に子機(ペリフェラル)を検出した際に呼び出される
    /// - Parameters:
    ///   - central: マネージャ
    ///   - peripheral: 子機(ペリフェラル)
    ///   - advertisementData: 検出した子機(ペリフェラル)のデータ
    ///   - RSSI: ペリフェラルの現在の受信信号強度インジケータ（RSSI）（デシベル単位）
    public func centralManager(_ central: CBCentralManager,
                               didDiscover peripheral: CBPeripheral,
                               advertisementData: [String : Any],
                               rssi RSSI: NSNumber) {
        
        defer {
            if delegate?.doWantToStopScanning() ?? false {
                _ = stop()
            }
        }
        
        var data = DiscoveryPeripheralData()
        data.rssi = Int(truncating: RSSI)
        
        // 子機(ペリフェラル)のアドバタイズの名前を取得
        data.advertisementName = peripheral.name

        // 取れる時と取れない時があるのでコメントアウト　※今後取れるかもしれないのでコードは残しておく
        // アドバタイズのサービスIDを指定してスキャンした場合
        // 　- フォア/バッグ両方とも取得可能
        // アドバタイズのサービスIDを指定せず全てを対象にスキャンした場合
        // 　- フォア:取得可能
        // 　- バッグ:取得不可
        // 子機(ペリフェラル)のアドバタイズServiceUUID
        //if let uuids = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID] {
        //    data.serviceIds = [String]()
        //    uuids.forEach { data.serviceIds!.append($0.uuidString) }
        //}
        //else if let uuids = advertisementData["kCBAdvDataHashedServiceUUIDs"]as? [CBUUID] {
        //    data.serviceIds = [String]()
        //    uuids.forEach { data.serviceIds!.append($0.uuidString) }
        //}

        // 子機(ペリフェラル)との接続が可能かを取得
        var isConnectable = false
        if let connectable = advertisementData["kCBAdvDataIsConnectable"] as? Bool {
            isConnectable = connectable
        }
        // タイムスタンプを取得
        if let timestamp = advertisementData["kCBAdvDataTimestamp"] as? TimeInterval {
            let date = Date(timeIntervalSinceReferenceDate: timestamp)
            data.discoveryTime = date
        }
    
        // 検出通知
        delegate?.didDiscoveredPeripheral(information: data, isConnectable: isConnectable)
        
        // 接続確認通知
        // 接続しない場合は、何もしない
        let result = delegate?.doWantToConnect(information: data) ?? false
        if result == false { return }
    }
}
