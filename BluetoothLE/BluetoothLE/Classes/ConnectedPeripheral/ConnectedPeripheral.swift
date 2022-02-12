//
//  ConnectedPeripheral.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/29.
//

import Foundation
import CoreBluetooth

/// 親機(セントラル)と接続済みの子機(ペリフェラル)サービスクラス
public class ConnectedPeripheral : NSObject {
    
    /// 接続している子機(ペリフェラル)のインスタンス
    private (set) var peripheral : CBPeripheral

    /// デリゲート
    public var delegate: ConnectedPeripheralDelegate? = nil
    
    /// 子機(ペリフェラル)検出時の情報
    public var discoveryData : DiscoveryPeripheralData;
  
    /// コンストラクタ
    /// - Parameters:
    ///   - peripheral: 接続済みの子機(ペリフェラル)
    ///   - discoveryData: 子機(ペリフェラル)検出時の情報
    init(peripheral: CBPeripheral, discoveryData: DiscoveryPeripheralData) {
        self.peripheral = peripheral
        self.discoveryData = discoveryData
        
        super.init()
        
        self.peripheral.delegate = self
    }
    
    /// 子機(ペリフェラル)の公開しているサービスを問い合わせる
    /// - Note: 全てのサービスを問い合わせるため、パフォーマンスが悪いため、fetchServicesWithServiceId(..)を使用してください。
    func fetchServices() {
        peripheral.discoverServices(nil)
    }
    
    /// 子機(ペリフェラル)の公開している指定されたサービスを取得する
    /// - Parameter serviceId: 取得するサービスID
    /// - Returns: サービス
    /// - throws: PeripheralServiceError.NotFetchedServices
    ///
    ///  対策: fetchServices()を実行してください
    func getService(serviceId:String) throws -> CBService? {
        guard let services = peripheral.services else {
            throw PeripheralServiceError.NotFetchedServices
        }
        
        guard let service = services.first(where: {
            $0.uuid.uuidString.caseInsensitiveCompare(serviceId) == .orderedSame
        }) else {
            return nil
        }
        
        return service
    }
    
    /// 子機(ペリフェラル)の公開している指定されたサービス内のデータを取得する
    /// - Parameter serviceId: 取得するサービスID
    /// - Parameter characteristicId: 取得するデータID
    /// - Returns: データ
    /// - throws: PeripheralServiceError.NotFetchedServices
    ///
    ///  対策: fetchServices()を実行してください
    ///
    /// - throws: PeripheralServiceError.NotFetchCharacteristics
    ///
    ///  対策: fetchCharacteristics(...)を実行してください
    func getCharacteristic(serviceId:String, characteristicId:String) throws -> CBCharacteristic? {
        
        guard let service = try getService(serviceId: serviceId) else { return nil }
        guard let list = service.characteristics else {
            throw PeripheralServiceError.NotFetchCharacteristics
        }
        
        guard let characteristic = list.first(where: {
            $0.uuid.uuidString.caseInsensitiveCompare(characteristicId) == .orderedSame
        }) else {
            return nil
        }
        
        return characteristic
    }
}

// MARK: - 外部公開

/// 親機(セントラル)と接続済みの子機(ペリフェラル)サービスクラス
extension ConnectedPeripheral {
    
    /// 子機(ペリフェラル)のID
    public var peripheralId : String {
        get {
            peripheral.identifier.uuidString
        }
    }
    
    /// 子機(ペリフェラル)の接続状況
    public var state : CBPeripheralState {
        get {
            return peripheral.state
        }
    }
    
    /// 子機(ペリフェラル)の公開している指定したサービスを問い合わせる
    /// - Parameter id: 特定の子機(ペリフェラル)を探すアドバタイズのサービスID
    public func fetchServicesWithServiceId(id:String) {
        peripheral.discoverServices([CBUUID(string: id)])
    }
    
    /// 子機(ペリフェラル)の公開している指定したサービス内のデータを問い合わせる
    /// - Parameter id: 特定の子機(ペリフェラル)を探すアドバタイズのサービスID
    /// - Returns: true:成功 false:失敗
    /// - throws: PeripheralServiceError.NotFetchedServices
    ///
    ///  対策: fetchServices()を実行してください
    public func fetchCharacteristics(id:String) throws -> Bool {
        guard let list = peripheral.services else {
            throw PeripheralServiceError.NotFetchedServices
        }
        guard let service = list.first(where: {
            $0.uuid.uuidString.caseInsensitiveCompare(id) == .orderedSame
        }) else {
            return false
        }
        
        peripheral.discoverCharacteristics(nil, for: service)
        
        return true
    }
    
    /// 子機(ペリフェラル)の公開しているサービス一覧を取得する
    /// - Returns: サービスUUIDの一覧
    /// - throws: PeripheralServiceError.NotFetchedServices
    ///
    ///  対策: fetchServices()を実行してください
    public func getServices() throws -> [String] {
        guard let list = peripheral.services else {
            throw PeripheralServiceError.NotFetchedServices
        }
        return list.map { $0.uuid.uuidString }
    }
    
    /// 子機(ペリフェラル)の公開している指定したサービス内のデータ一覧を取得する
    /// - Parameter id: 特定の子機(ペリフェラル)を探すアドバタイズのサービスID
    /// - Returns: データUUID一覧
    /// - throws: PeripheralServiceError.NotFetchedServices
    ///
    ///  対策: fetchServices()を実行してください
    ///
    /// - throws: PeripheralServiceError.NotFetchCharacteristics
    ///
    ///  対策: fetchCharacteristics(...)を実行してください
    public func getCharacteristics(id:String) throws -> [String] {
        guard let service = try getService(serviceId: id) else { return [] }
        guard let list = service.characteristics else {
            throw PeripheralServiceError.NotFetchCharacteristics
        }
       
        return list.map { $0.uuid.uuidString }
    }
    
    /// 子機(ペリフェラル)の公開している指定したサービス内のデータに書き込む
    /// - Parameters:
    ///   - serviceId: 子機(ペリフェラル)のアドバタイズのサービスID
    ///   - characteristicId: 子機(ペリフェラル)が公開しているサービス内のデータID
    ///   - value: 書き込むデータ
    /// - Returns: true:成功 false:失敗
    /// - throws: PeripheralServiceError.NotFetchedServices
    ///
    ///  対策: fetchServices()を実行してください
    ///
    /// - throws: PeripheralServiceError.NotFetchCharacteristics
    ///
    ///  対策: fetchCharacteristics(...)を実行してください
    public func writeValue(serviceId:String, characteristicId:String, value:Data) throws -> Bool {
        
        guard let characteristic = try getCharacteristic(
            serviceId: serviceId,
            characteristicId: characteristicId) else { return false }
     
        peripheral.setNotifyValue(false, for: characteristic)
        peripheral.writeValue(value, for: characteristic, type: .withResponse)
        
        return true
    }
    
    /// 子機(ペリフェラル)の公開している指定したサービス内のデータを読み込む
    /// - Parameters:
    ///   - serviceId: 子機(ペリフェラル)のアドバタイズのサービスID
    ///   - characteristicId: 子機(ペリフェラル)が公開しているサービス内のデータID
    /// - Returns: true:成功 false:失敗
    /// - throws: PeripheralServiceError.NotFetchedServices
    ///
    ///  対策: fetchServices()を実行してください
    ///
    /// - throws: PeripheralServiceError.NotFetchCharacteristics
    ///
    ///  対策: fetchCharacteristics(...)を実行してください
    public func readValue(serviceId:String, characteristicId:String) throws -> Bool {
        
        guard let characteristic = try getCharacteristic(
            serviceId: serviceId,
            characteristicId: characteristicId) else { return false }
        
        peripheral.setNotifyValue(false, for: characteristic)
        peripheral.readValue(for: characteristic)
        
        return true
    }
}
