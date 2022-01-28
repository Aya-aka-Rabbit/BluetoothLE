//
//  ViewController.swift
//  Demo Peripheral(子機)
//
//  Created by r.nishizaki on 2022/01/22.
//

import UIKit
import BluetoothLE

class ViewController: UIViewController {

    /// 子機のアドバタイズ名
    let AdvertisementName = "Sample_Peripheral"
    
    /// 子機が提供するサービスのID
    let ServiceID = "1645070b-d162-1b08-dde0-69d7a4bdfc26"
    
    /// 子機のサービスオブジェクト
    var service : PeripheralService? = nil
    
    /// サービスのIDを表示するラベル
    @IBOutlet weak var text1: UILabel!
    
    /// 画面表示完了時の処理
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
        _ = service?.addAdvertisementService(uuid: uuid)
        
        do {
            _ = try service?.start()
            text1.text = uuid
        }
        catch let error {
            print(error.localizedDescription)
        }
       
    }
    
    /// アドバタイズを停止
    /// - Parameter sender: ボタン
    @IBAction func onAdvertiseStop(_ sender: Any) {
        _ = service?.stop()
    }
}

extension ViewController : PeripheralServiceDelegate  {
    
    /// セントラルと通信する際のアドバタイズの名前を取得する
    /// - Returns: アドバタイズの名前
    func advertisementLocalName() -> String {
        return AdvertisementName
    }

    /// Bluetoothの電源が現在オンになった通知
    func bluetoothPoweredOn() { print("Peripheral Service + bluetoothPoweredOn") }
   
    /// Bluetoothの電源が現在オフになった通知
    func bluetoothPoweredOff() { print("Peripheral Service + bluetoothPoweredOff") }
    
    /// BluetoothLowEnergyの使用が許可されていない通知
    func bluetoothUnauthorized() { print("Peripheral Service + bluetoothUnauthorized") }

}


