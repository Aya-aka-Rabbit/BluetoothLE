//
//  PeripheralService.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/23.
//

import Foundation
import CoreBluetooth

/// 子機(ペリフェラル)としてサービスを提供し、親機(セントラル)と通信するクラス
final public class PeripheralService : NSObject {
    
    /// ペリフェラルマネージャ
    private var manager: CBPeripheralManager? = nil
    
    /// PeripheralServiceのidentifier
    public let id = UUID().uuidString
    
    /// アドバタイズのサービスIDリスト
    var serviceList : [CBMutableService] = []
    
    /// デリゲート
    public var delegate: PeripheralServiceDelegate? = nil
    
    /// ペリフェラルマネージャオプション
    private let managerOptions = [
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

/// 子機(ペリフェラル)としてサービスを提供し、親機(セントラル)と通信するクラス
extension PeripheralService : BluetoothLEServiceProtocol {
    
    /// PeripheralServiceのidentifier
    public var identifier: String {
        return id
    }
    
    /// アドバタイズ実行状態
    public var isAdvertising: Bool {
        return manager?.isAdvertising ?? false
    }
    
    /// アドバタイズのサービスIDを追加する
    /// - Parameter builder: サービスビルダー
    /// - Returns: 追加後のサービス数
    /// - Remark: BLEで用いるサービス用のUUIDは以下の方法で作成
    ///
    /// -- ターミナルでuuidgenを入力した文字列
    ///
    /// -- UUID().uuidStringで作成
    public func addAdvertisementService(builder: PeripheralServiceBuilder) -> Bool {
        guard let service = builder.service else { return false }
        
        manager?.add(service)
        serviceList.append(service)
        
        return true
    }
    
    /// アドバタイズのサービスIDを全て削除する
    public func clearServiceUUID() {
        serviceList.removeAll()
        manager?.removeAllServices()
    }
    
    /// アドバタイズを開始
    /// - Returns: true:成功 false:失敗
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
        
        if serviceList.isEmpty {
            throw PeripheralServiceError.AdvertisementServiceIdNotAdded
        }

        // アドバタイズデータの作成
        let advertisementData = [
            CBAdvertisementDataLocalNameKey: localName!,
            CBAdvertisementDataServiceUUIDsKey:serviceList.map { $0.uuid }
        ] as [String : Any]
        
        manager!.startAdvertising(advertisementData)
        return true;
    }
    
    /// アドバタイズを停止
    /// - Returns: true:成功 false:失敗
    public func stop() -> Bool {
        guard manager != nil else { return false }
        
        if isAdvertising {
            manager!.stopAdvertising()
        }
        
        return true;
    }
}


