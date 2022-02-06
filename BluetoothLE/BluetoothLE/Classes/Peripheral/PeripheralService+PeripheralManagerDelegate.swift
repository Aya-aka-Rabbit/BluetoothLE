//
//  PeripheralService+PeripheralManagerDelegate.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/23.
//

import Foundation
import CoreBluetooth

extension PeripheralService : CBPeripheralManagerDelegate {
    
    /// 周辺機器マネージャーがローカルGATTデータベースにサービスを公開したことの通知をハンドリング
    /// - Parameters:
    ///   - peripheral: サービスを追加するペリフェラルマネージャ
    ///   - service: ローカルGATTデータベースに追加されたサービス
    ///   - error: エラー情報
    public func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        // NOP
    }
        
    /// アドバタイズを開始した際に呼び出される
    /// - Parameters:
    ///   - peripheral: 開始した周辺機器マネージャー
    ///   - error: エラー情報
    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        delegate?.didStartAdvertising(error: error)
    }
    
    /// ローカル周辺機器が動的値を持つキャラクタリスティックの属性プロトコル（ATT）書き込み要求を受信した際に呼び出される
    /// - Parameters:
    ///   - peripheral: リクエストを受信したペリフェラルマネージャー
    ///   - requests: 1つ以上のCBATTRequestオブジェクトのリスト
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
    
        // 受信データの取り出し
        requests.forEach { request in
            
            print(String(data: request.value!, encoding: .utf8))
            print(request.characteristic.properties.rawValue)
            print("didReceiveWrite\(request.characteristic.uuid.uuidString)")
            // キャラクタリスティックで絞り込む
            let characteristicUUID = request.characteristic.uuid
            let myCharacteristics = serviceList.compactMap{ $0.characteristics }.flatMap{ $0 }
            let characteristicsList = myCharacteristics.filter {
                $0.uuid.uuidString.caseInsensitiveCompare(characteristicUUID.uuidString) == .orderedSame
            }
            if characteristicsList.count == 0 { return }
            guard let service = characteristicsList[0].service else { return }
                  
            // 通知データを作成
            let data = WriteRequestData(service: service,
                                        characteristic: characteristicsList[0],
                                        data: request.value)
            let central = ConnectedCentral(central: request.central)
            
            // 更新通知
            if let updateValue = delegate?.AcquireWriteDataByWriteRequestFrom(central: central, request: data) {
                guard let characteristics = characteristicsList[0] as? CBMutableCharacteristic else { return }
                characteristics.value = updateValue
            }
            
            // レスポンスを更新
            let responseCode = delegate?.didReceiveRequest(central: central, request: data) ?? .success
            peripheral.respond(to: request, withResult: responseCode.toErrorCode())
        }
    }
    
    /// ローカル周辺機器が動的値を持つキャラクタリスティックの属性プロトコル（ATT）読み取り要求を受信した際に呼び出される
    /// - Parameters:
    ///   - peripheral: リクエストを受信したペリフェラルマネージャー
    ///   - requests: CBATTRequestオブジェクト
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        
        print("didReceiveRead\(request.characteristic.uuid.uuidString)")
        // キャラクタリスティックで絞り込む
        let characteristicUUID = request.characteristic.uuid
        let myCharacteristics = serviceList.compactMap{ $0.characteristics }.flatMap{ $0 }
        let characteristicsList = myCharacteristics.filter {
            $0.uuid.uuidString.caseInsensitiveCompare(characteristicUUID.uuidString) == .orderedSame
        }
        if characteristicsList.count == 0 { return }
        guard let service = characteristicsList[0].service else { return }
            
        // 通知データを作成
        let data = ReadRequestData(service: service,
                                    characteristic: characteristicsList[0])
        let central = ConnectedCentral(central: request.central)

        // 読み取り通知
        if let readValue = delegate?.AcquireReadDataByReadRequestFrom(central: central, request: data) {
            request.value = readValue
        }
        
        // レスポンスを更新
        let responseCode = delegate?.didReceiveRequest(central: central, request: data) ?? .success
        peripheral.respond(to: request, withResult: responseCode.toErrorCode())
    }
    
    /// 親機(セントラル)がキャラクタリスティックをサブスクライブした際に呼び出される
    /// - Parameters:
    ///   - peripheral: 親機(セントラル)に接続している子機(ペリフェラル)
    ///   - central: 親機(セントラル)
    ///   - characteristic: サブスクライブされたキャラクタリスティック
    public func peripheralManager(_ peripheral: CBPeripheralManager,
                                  central: CBCentral,
                                  didSubscribeTo characteristic: CBCharacteristic) {
        delegate?.didSubscribeTo(central: ConnectedCentral(central: central), id: characteristic.uuid.uuidString)
    }
    
    /// 親機(セントラル)がキャラクタリスティックをサブスクライブを解除した際に呼び出される
    /// - Parameters:
    ///   - peripheral: 親機(セントラル)に接続している子機(ペリフェラル)
    ///   - central: 親機(セントラル)
    ///   - characteristic: サブスクライブを解除されたキャラクタリスティック
    public func peripheralManager(_ peripheral: CBPeripheralManager,
                                  central: CBCentral,
                                  didUnsubscribeFrom characteristic: CBCharacteristic) {
        delegate?.didUnsubscribeFrom(central: ConnectedCentral(central: central), id: characteristic.uuid.uuidString)
    }
    
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
