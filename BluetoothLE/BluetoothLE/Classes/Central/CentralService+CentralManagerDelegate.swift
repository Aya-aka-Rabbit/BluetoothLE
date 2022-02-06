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
        
        var data = DiscoveryPeripheralData(peripheral)
        data.rssi = Int(truncating: RSSI)
        
        // 子機(ペリフェラル)のアドバタイズの名前を取得
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            data.advertisementName = localName
        }
        
        data.name = peripheral.name

        // 取れる時と取れない時があるのでコメントアウト　※今後正しく取れるかもしれないのでコードは残しておく
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
    }
    
    /// 子機(ペリフェラル)との接続に成功した場合に呼び出される
    /// - Parameters:
    ///   - central: マネージャ
    ///   - peripheral: 子機(ペリフェラル)
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.didPeripheralConnect(peripheralId: peripheral.identifier.uuidString, error: nil)
    }
    
    /// 子機(ペリフェラル)との接続に失敗した場合に呼び出される
    /// - Parameters:
    ///   - central: マネージャ
    ///   - peripheral: 子機(ペリフェラル)
    ///   - error: エラー情報
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.didPeripheralConnect(peripheralId: peripheral.identifier.uuidString, error: error)
    }
    
    /// 子機(ペリフェラル)と切断した場合に呼び出される
    /// - Parameters:
    ///   - central: マネージャ
    ///   - peripheral: 子機(ペリフェラル)
    ///   - error: エラー情報
    /// - Note: 接続を切断したとしても、基盤となる物理リンクがすぐに切断されるとは限りません
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral,
                               error: Error?) {
        delegate?.didPeripheralDisconnect(peripheralId: peripheral.identifier.uuidString, error: error)
    }
}
