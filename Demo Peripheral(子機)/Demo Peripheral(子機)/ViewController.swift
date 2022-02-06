//
//  ViewController.swift
//  Demo Peripheral(子機)
//
//  Created by r.nishizaki on 2022/01/22.
//

import UIKit
import BluetoothLE

class ViewController: UIViewController {

    /// 子機(ペリフェラル)のアドバタイズ名
    let AdvertisementName = "Sample_Peripheral"
    
    /// 子機(ペリフェラル)が提供するサービスのID
    let ServiceID = "1645070b-d162-1b08-dde0-69d7a4bdfc26"
    
    /// 子機(ペリフェラル)が提供するサービスの値を示すキャラクタリスティック
    let ServiceWriteVlaue = "3A49B33B-2B3F-495B-AE92-FF49DDEB6753"

    /// 子機(ペリフェラル)が提供するサービスの値を示すキャラクタリスティック
    let ServiceReadOnlyValue = "9AFF41FB-BCBF-4E17-AA93-9481F9E102E9"
    
    /// 子機(ペリフェラル)が提供するサービスの値を示すキャラクタリスティック
    let ServiceReadWriteValue = "A76AFFC3-3874-4546-B532-0D6CD73D5B93"
    
    /// 子機(ペリフェラル)のサービスオブジェクト
    var service : PeripheralService? = nil
    
    /// サービスのIDを表示するラベル
    @IBOutlet weak var text1: UILabel!
    
    /// 書き込み受信データを表示するラベル
    @IBOutlet weak var text2: UILabel!

    /// 読み取りデータ用のテキストボックス
    @IBOutlet weak var textbox: UITextField!
    
    /// 画面ロード完了時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = ServiceManager.sharedPeripheral()
        service?.delegate = self
    }
    
    /// アドバタイズを開始して、セントラル(親機)に存在を知らせる
    /// - Parameter sender: ボタン
    @IBAction func onAdvertiseStart(_ sender: Any) {
        let uuid = ServiceID
        _ = service?.clearServiceUUID()
     

        do {
            // (1) 公開するサービスを作成するビルダーを作成
            let builder = PeripheralServiceBuilder(serviceId: uuid)
            // (2) 公開するデータを追加
            _ = builder.appendWriteCharacteristic(code: ServiceWriteVlaue)
            _ = builder.appendReadCharacteristic(code: ServiceReadOnlyValue)
            _ = builder.appendCharacteristic(code: ServiceReadWriteValue)
            // (3) サービスを追加
            _ = service?.addAdvertisementService(builder: builder)
            // (3) サービスを公開
            _ = try service?.start()
            text1.text = uuid
        }
        catch let error {
            print(error)
        }
       
    }
    
    /// アドバタイズを停止
    /// - Parameter sender: ボタン
    @IBAction func onAdvertiseStop(_ sender: Any) {
        _ = service?.stop()
    }
}

extension ViewController : PeripheralServiceDelegate  {
    
    /// 親機(セントラル)と通信する際のアドバタイズの名前を取得する
    /// - Returns: アドバタイズの名前
    func advertisementLocalName() -> String {
        return AdvertisementName
    }
    
    /// 親機(セントラル)から要求を受信した際の通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - request: 要求データ
    /// - Returns: 要求に対する応答コード
    func didReceiveRequest(central:ConnectedCentral, request:RequestData) -> ResponseCode {
        return ResponseCode.success
    }
    
    /// 親機(セントラル)から書込要求を受信した際に書込データを要求する通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - request: 書き込み要求データ
    /// - Returns: 親機(セントラル)に公開しているデータに対して書き込む最新データ
    func AcquireWriteDataByWriteRequestFrom(central:ConnectedCentral, request:WriteRequestData) -> Data? {
        if request.characteristicId?.caseInsensitiveCompare(ServiceWriteVlaue) == .orderedSame {
            text2.text = request.getStringValue()
            return request.getValue()
        }
        if request.characteristicId?.caseInsensitiveCompare(ServiceReadWriteValue) == .orderedSame {
            return (request.getStringValue()! + ":更新").data(using: .utf8)
        }
        return nil
    }

    /// 親機(セントラル)から読取要求を受信した際の通知
    /// - Parameters:
    ///   - central: 親機(セントラル)
    ///   - request: 読み取り要求データ
    /// - Returns: 親機(セントラル)に公開しているデータに対して返却する最新データ
    func AcquireReadDataByReadRequestFrom(central:ConnectedCentral, request:ReadRequestData) -> Data? {
        
        if request.characteristicId?.caseInsensitiveCompare(ServiceReadOnlyValue) == .orderedSame {
            return textbox.text!.data(using: .utf8)
        }
        if request.characteristicId?.caseInsensitiveCompare(ServiceReadWriteValue)  == .orderedSame {
            return request.getValue()
        }
        return nil
    }
    
    /// Bluetoothの電源が現在オンになった通知
    func bluetoothPoweredOn() { print("Peripheral Service + bluetoothPoweredOn") }
   
    /// Bluetoothの電源が現在オフになった通知
    func bluetoothPoweredOff() { print("Peripheral Service + bluetoothPoweredOff") }
    
    /// BluetoothLowEnergyの使用が許可されていない通知
    func bluetoothUnauthorized() { print("Peripheral Service + bluetoothUnauthorized") }

}


