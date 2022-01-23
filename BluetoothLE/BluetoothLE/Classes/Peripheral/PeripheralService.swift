//
//  PeripheralService.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/23.
//
//  子機(ペリフェラル)としてサービスを提供し、親機(セントラル)と通信する
//

import Foundation
import CoreBluetooth

// MARK: - 外部非公開
final public class PeripheralService : NSObject {
    // ペリフェラルマネージャ
    var manager: CBPeripheralManager? = nil
    
    // PeripheralServiceのUUID
    let uuid = UUID().uuidString
    
    // アドバタイズのサービスIDリスト
    var serviceUUID : [CBUUID] = []
    
    // デリゲート
    public var delegate: PeripheralServiceDelegate? = nil
    
    // ペリフェラルマネージャオプション
    let managerOptions = [
        // Bluetoothが電源オフ状態にある場合にシステムが警告するようにする
        CBPeripheralManagerOptionShowPowerAlertKey: true
    ]
    
    /// コンストラクタ
    override init() {
        super.init()
        
        //　queueはメインスレッドを使用する
        manager = CBPeripheralManager(delegate: self, queue: nil, options: managerOptions)
    }
}

// MARK: - 外部公開
extension PeripheralService : Service {
    
    /// PeripheralServiceのID
    public var serviceId: String {
        return uuid
    }
    
    /// アドバタイズ実行状態
    public var isAdvertising: Bool {
        return manager?.isAdvertising ?? false
    }
    
    /// アドバタイズのサービスIDを追加する
    /// - Parameter uuid: UUIDの文字列
    /// - Returns: 追加後のサービス数
    /// - Remark: BLEで用いるサービス用のUUIDは以下の方法で作成
    ///
    /// -- ターミナルでuuidgenを入力した文字列
    ///
    /// -- UUID().uuidStringで作成
    public func addAdvertisementService(uuid : String) -> Int {
        if uuid.isEmpty { return -1 }
        serviceUUID.append(CBUUID(string: uuid))
        return serviceUUID.count
    }
    
    /// アドバタイズのサービスIDを全て削除する
    /// - Returns: 削除後のサービス数
    public func clearServiceUUID() -> Int {
        serviceUUID.removeAll()
        return serviceUUID.count
    }
    
    /// アドバタイズを開始
    /// - Returns: true:成功 flase:失敗
    /// - throws: PeripheralServiceError.AdvertisementServiceIdNotAdded
    ///
    ///  対策: AddAdvertisementService(...)でサービスを追加してください
    ///
    /// - throws: PeripheralServiceError.AlreadyAdvertised
    ///
    ///  対策: stop()で停止後にstart()を実行してください
    public func start() throws -> Bool {
        
        guard manager != nil else { return false }
        
        if isAdvertising {
            throw PeripheralServiceError.AlreadyAdvertised
        }
        
        var localName = delegate?.advertisementLocalName()
        if localName?.isEmpty ?? true {
            localName = "PeripheralDevice"
        }
        
        if serviceUUID.isEmpty {
            throw PeripheralServiceError.AdvertisementServiceIdNotAdded
        }
        
        // アドバタイズデータの作成
        let advertisementData = [
            CBAdvertisementDataLocalNameKey: localName!,
            CBAdvertisementDataServiceUUIDsKey:serviceUUID
        ] as [String : Any]
        
        manager!.startAdvertising(advertisementData)
        return true;
    }
    
    /// アドバタイズを停止
    /// - Returns: true:成功 flase:失敗
    public func stop() -> Bool {
        guard manager != nil else { return false }
        
        if isAdvertising {
            manager!.stopAdvertising()
        }
        
        return true;
    }
}


