//
//  CentralService.swift
//  BluetoothLE
//
//  親機(セントラル)としてサービスを提供し、子機(ペリフェラル)と通信する
//

import Foundation
import CoreBluetooth

final public class CentralService : NSObject {
 
    // セントラルマネージャ
    var manager: CBCentralManager?
    
    // CentralServiceのidentifier
    public let id = UUID().uuidString
    
    // デリゲート
    public var delegate: CentralerviceDelegate? = nil
    
    // セントラルマネージャオプション
    let managerOptions = [
        // Bluetoothが電源オフ状態にある場合にシステムが警告するようにする
        CBCentralManagerOptionShowPowerAlertKey: true
    ]
    
    /// コンストラクタ
    override init() {
        super.init()
        
        //　queueはメインスレッドを使用する
        manager = CBCentralManager(delegate: self, queue: nil, options: managerOptions)
    }
}

// MARK: - 外部公開
extension CentralService : Service {
    
    /// CentralServiceのidentifier
    public var identifier: String {
        return id
    }
    
    /// スキャン実行状態
    public var isScanning: Bool {
        return manager?.isScanning ?? false
    }
    
    /// 周囲の子機(ペリフェラル)を探すためにスキャンを実行する[非推奨]
    /// - Parameters:
    ///   - allowDuplicates: 重複フィルタリング有効にする場合は、trueを指定 (デフォルトはfalse)
    /// - Returns: true:成功 false:失敗
    /// - throws: CentralServiceError.AlreadyScanning
    ///
    ///  対策: stop()で停止後にstart()を実行してください
    /// - Note: 近くにある周辺機器を全て探すため、非効率
    ///
    ///  startWithServiceIdの使用を推奨する
    public func start(allowDuplicates:Bool = false) throws -> Bool {
        
        return try startWithServiceId(id:"", allowDuplicates: allowDuplicates)
    }
    
    /// アドバタイズのサービスIDを指定して周囲の子機(ペリフェラル)を探すためにスキャンを実行する
    /// - Parameters:
    ///   - id: 特定の子機(ペリフェラル)を探すアドバタイズのサービスID
    ///   - allowDuplicates: 重複フィルタリング有効にする場合は、trueを指定 (デフォルトはfalse)
    /// - Returns: true:成功 false:失敗
    /// - throws: CentralServiceError.AlreadyScanning
    ///
    ///  対策: stop()で停止後にstart()を実行してください
    public func startWithServiceId(id:String, allowDuplicates:Bool = false) throws -> Bool {
        
        guard manager != nil else { return false }
        
        if isScanning {
            throw CentralServiceError.AlreadyScanning
        }
        
        // スキャン時のオプション
        let options = [
            // 重複フィルタリングなしでスキャンを実行するかどうかを指定
            CBCentralManagerScanOptionAllowDuplicatesKey: allowDuplicates
        ]
        
        // サービスのUUIDを指定せず全てのペリフェラルを探す
        if (id.isEmpty) {
            manager?.scanForPeripherals(withServices: nil, options: options)
        }
        // サービスのUUIDを指定する
        else {
            let serviceId: CBUUID = CBUUID(string: id)
            manager?.scanForPeripherals(withServices: [serviceId], options: options)
        }
      
        return true;
    }
    
    /// スキャンを停止する
    /// - Returns: true:成功 false:失敗
    public func stop() -> Bool {
        guard manager != nil else { return false }
        
        if isScanning {
            manager!.stopScan()
        }
        
        return true;
    }
}
