//
//  CentralService.swift
//  BluetoothLE
//
//  親機(セントラル)としてサービスを提供し、子機(ペリフェラル)と通信する
//

import Foundation
import CoreBluetooth

final public class CentralService : NSObject {
 
    /// セントラルマネージャ
    private var manager: CBCentralManager?
    
    /// CentralServiceのidentifier
    public let id = UUID().uuidString
    
    /// デリゲート
    public var delegate: CentralServiceDelegate? = nil
    
    /// セントラルマネージャオプション
    private let managerOptions = [
        // Bluetoothが電源オフ状態にある場合にシステムが警告するようにする
        CBCentralManagerOptionShowPowerAlertKey: true
    ]
    
    /// 接続時のオプション
    private let connectOptions = [
        // 周辺機器をバックグラウンドで接続するときにシステムがアラートを表示するかどうか
        CBConnectPeripheralOptionNotifyOnConnectionKey: true,
        // バックグラウンドで周辺機器を切断したときにシステムがアラートを表示するかどうか
        CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,
        // 周辺機器から送信された通知に対してシステムがアラートを表示するかどうか
        CBConnectPeripheralOptionNotifyOnNotificationKey: true
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
    func start(allowDuplicates:Bool = false) throws -> Bool {
        
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
    
    /// 子機(ペリフェラル)との接続を行う
    /// - Parameters:
    ///   - data: 検出時の子機(ペリフェラル)の情報
    /// - Returns: 接続した子機(ペリフェラル)オブジェクト
    /// - throws: CentralServiceError.AlreadyConnected
    ///
    ///  対策: 既に接続されているため、一度切断してください
    public func connect(information data:DiscoveryPeripheralData) throws -> ConnectedPeripheral? {
        
        guard let _ = data.discoveryTime else { return nil}
        guard let _ = data.rssi else { return nil }
        guard let _ = data.peripheral else { return nil }
        if data.peripheral?.state == .connected { throw CentralServiceError.AlreadyConnected }
        if data.peripheral?.state == .connecting { throw CentralServiceError.AlreadyConnected }
        
        let connectionObject = ConnectedPeripheral(peripheral: data.peripheral!, discoveryData: data)
        
        // 接続
        manager?.connect(data.peripheral!, options: connectOptions)
        
        return connectionObject
    }
    
    /// 子機(ペリフェラル)との再接続を行う
    /// - Parameters:
    ///   - connection: 接続した子機(ペリフェラル)オブジェクト
    /// - Returns: true:成功 false:失敗
    /// - throws: CentralServiceError.AlreadyConnected
    ///
    ///  対策: 既に接続されているため、一度切断してください
    public func reconnect(connection:ConnectedPeripheral) throws-> Bool {
        
        guard let _ = connection.discoveryData.discoveryTime else { return false }
        guard let _ = connection.discoveryData.rssi else { return false }
        guard let _ = connection.discoveryData.peripheral else { return false }
        if connection.state == .connected { throw CentralServiceError.AlreadyConnected }
        if connection.state == .connecting { throw CentralServiceError.AlreadyConnected }
        
        // 接続
        manager?.connect(connection.peripheral, options: connectOptions)
        
        return true
    }
    
    /// 子機(ペリフェラル)との接続を切断する
    /// - Parameter connection: 接続した子機(ペリフェラル)オブジェクト
    /// - Returns: true:成功 false:失敗
    public func disconnect(connection:ConnectedPeripheral) -> Bool {
        
        if connection.state == .disconnected { return false }
        if connection.state == .disconnecting { return false }
        
        manager?.cancelPeripheralConnection(connection.peripheral)
    
        return true
    }
}
