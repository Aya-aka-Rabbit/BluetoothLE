//
//  DetailViewController.swift
//  Demo Central(親機)
//
//  Created by r.nishizaki on 2022/01/29.
//

import UIKit
import BluetoothLE

class DetailViewController: UIViewController {

    /// 子機(ペリフェラル)が提供するサービスのID
    let ServiceID = "1645070b-d162-1b08-dde0-69d7a4bdfc26"
    
    /// 子機(ペリフェラル)が提供するサービスの値を示すキャラクタリスティック
    let ServiceWriteVlaue = "3A49B33B-2B3F-495B-AE92-FF49DDEB6753"
    
    /// 子機(ペリフェラル)が提供するサービスの値を示すキャラクタリスティック
    let ServiceReadOnlyValue = "9AFF41FB-BCBF-4E17-AA93-9481F9E102E9"
    
    /// 子機(ペリフェラル)が提供するサービスの値を示すキャラクタリスティック
    let ServiceReadWriteValue = "A76AFFC3-3874-4546-B532-0D6CD73D5B93"
    
    /// 親機(セントラル)のサービスオブジェクト
    var service : CentralService? = nil
    
    /// 子機(ペリフェラル)のサービス一覧
    var serviceIdList : [String] = []
 
    /// 子機(ペリフェラル)のサービス内のデータ一覧
    var characteristicList : [String] = []
    
    /// 子機(ペリフェラル)の情報
    var peripheralInfo : ConnectedPeripheral? = nil
    
    /// 子機(ペリフェラル)のID
    @IBOutlet weak var id: UILabel!
    
    /// 子機(ペリフェラル)のアドバタイズの名前
    @IBOutlet weak var advertiseName: UILabel!
    
    /// 子機(ペリフェラルの名前
    @IBOutlet weak var name: UILabel!
    
    /// 子機(ペリフェラル)の検出時間
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var readWriteLabel: UILabel!
    
    /// テキストボックス
    @IBOutlet weak var textbox: UITextField!
    
    /// テキストボックス
    @IBOutlet weak var readWriteTextbox: UITextField!
    
    /// テキストボックス
    @IBOutlet weak var readTextbox: UITextField!
    
    /// 画面ロード完了時の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲートは設定しない
        service = ServiceManager.sharedCentral()
        
        // 接続後の通知を受け取るため設定
        peripheralInfo?.delegate = self
        
        if let id = peripheralInfo?.peripheralId {
            self.id.text = id
        }
        
        if let name = peripheralInfo?.discoveryData.name {
            self.name.text = name
        }
        
        if let advertisementName = peripheralInfo?.discoveryData.advertisementName {
            advertiseName.text = advertisementName
        }
        
        if let time = peripheralInfo?.discoveryData.discoveryTime {
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
            dateFormatter.dateFormat = "yyyy年MM月dd日(EEEEE) HH時mm分ss秒"
            self.time.text = dateFormatter.string(from: time)
        }
        
        navigationItem.title = "子機の情報(接続中)"
        
        // サービス一覧を取得
        peripheralInfo?.fetchServicesWithServiceId(id: ServiceID)
    }
    
    /// 子機(ペリフェラル)との接続を切断
    /// - Parameter sender: ボタン
    @IBAction func onDisconnect(_ sender: Any) {
        guard let info = peripheralInfo else { return }
        _ = service?.disconnect(connection: info)
        
        navigationItem.title = "子機の情報(切断済み)"
        
        navigationController?.popViewController(animated: true)
    }
    
    /// 子機(ペリフェラル)に書き込み専用文字列を送信
    /// - Parameter sender: ボタン
    @IBAction func onSendStringValue(_ sender: Any) {
        
        var text = textbox.text ?? ""
        text = text.isEmpty ? "テストデータ" : text
        textbox.endEditing(true)
        
        do {
            guard let sendValue = text.data(using: .utf8) else { return }
            _ = try peripheralInfo?.writeValue(
                serviceId: ServiceID, characteristicId: ServiceWriteVlaue, value: sendValue)
        }
        catch let error {
            print(error)
        }
    }
    
    /// 子機(ペリフェラル)に読み書き用文字列を送信
    /// - Parameter sender: ボタン
    @IBAction func onSendReadWriteValue(_ sender: Any) {
        var text = readWriteTextbox.text ?? ""
        text = text.isEmpty ? "テストデータ" : text
        readWriteTextbox.endEditing(true)
        
        do {
            guard let sendValue = text.data(using: .utf8) else { return }
            _ = try peripheralInfo?.writeValue(
                serviceId: ServiceID, characteristicId: ServiceReadWriteValue, value: sendValue)
        }
        catch let error {
            print(error)
        }
    }
    
    /// 子機(ペリフェラル)から読み書き用文字列を受信
    /// - Parameter sender: ボタン
    @IBAction func onReadWriteValue(_ sender: Any) {
        do {
            _ = try peripheralInfo?.readValue(
                serviceId: ServiceID, characteristicId: ServiceReadWriteValue)
        }
        catch let error {
            print(error)
        }
    }
    
    /// 子機(ペリフェラル)から読み取り専用文字列を受信
    /// - Parameter sender: ボタン
    @IBAction func onReadReadOnlyStringValue(_ sender: Any) {
        
        do {
            _ = try peripheralInfo?.readValue(
                serviceId: ServiceID, characteristicId: ServiceReadOnlyValue)
        }
        catch let error {
            print(error)
        }
    }
}

extension DetailViewController : ConnectedPeripheralDelegate  {
    
    /// 子機(ペリフェラル)の公開しているサービスを検出したい際の通知
    /// - Parameters:
    ///   - connectedPeripheral: 接続した子機(ペリフェラル)オブジェクト
    ///   - services: 公開しているサービスUUIDの一覧
    ///   - error: エラー情報
    func didDiscoverServices(_ connectedPeripheral:ConnectedPeripheral, services:[String], error: Error?) {
        serviceIdList = services
        if services.count > 0 {
            // データ一覧を取得
            _ = try? connectedPeripheral.fetchCharacteristics(id: services[0])
        }
    }
    
    /// 子機(ペリフェラル)の公開しているサービス内のデータを検出した際の通知
    /// - Parameters:
    ///   - connectedPeripheral: 接続した子機(ペリフェラル)オブジェクト
    ///   - Characteristics: サービス内のデータUUID一覧
    ///   - error: エラー情報
    func didDiscoverCharacteristics(_ connectedPeripheral:ConnectedPeripheral, characteristics:[String], error: Error?) {
        characteristicList = characteristics
    }
    
    /// 子機(ペリフェラル)からリクエストに対するレスポンスを検出した際の通知
    /// - Parameters:
    ///   - connectedPeripheral: 接続した子機(ペリフェラル)オブジェクト
    ///   - response: レスポンスデータ
    ///   - error: エラー情報
    func didReceivedResponseFrom(_ connectedPeripheral:ConnectedPeripheral, response:ResponseData, error: Error?) {
        
        if response.characteristicId?.caseInsensitiveCompare(ServiceReadOnlyValue) == .orderedSame {
            readTextbox.text = response.getStringValue()
            return
        }
        
        if response.characteristicId?.caseInsensitiveCompare(ServiceReadWriteValue) == .orderedSame {
            readWriteLabel.text = response.getStringValue()
            return
        }
    }
}
