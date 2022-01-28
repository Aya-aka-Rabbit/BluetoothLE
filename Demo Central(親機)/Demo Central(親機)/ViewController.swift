//
//  ViewController.swift
//  Demo Central(親機)
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
    
    /// 親機のサービスオブジェクト
    var service : CentralService? = nil
    
    /// スキャンが完了したかどうか
    var scanCompleted = false
    
    /// 画面表示完了時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = ServiceManager.sharedCentral()
        service?.delegate = self
    }
    
    /// スキャンを開始して、子機(ペリフェラル)を探す
    /// - Parameter sender: ボタン
    @IBAction func onScanStart(_ sender: Any) {
        scanCompleted = false;
        do {
            _ = try service?.startWithServiceId(id: "1645070b-d162-1b08-dde0-69d7a4bdfc26")
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// スキャンを停止
    /// - Parameter sender: ボタン
    @IBAction func onAdvertiseStop(_ sender: Any) {
        scanCompleted = true;
        _ = service?.stop()
    }
}

extension ViewController : CentralerviceDelegate  {
    
    /// 親機(セントラル)がスキャン中に検出した子機(ペリフェラル)に接続するかどうか
    /// - Parameters:
    ///   - data: 子機(ペリフェラル)の情報
    /// - Returns: true:接続する false:接続しない
    func doWantToConnect(information data: DiscoveryPeripheralData) -> Bool {
        scanCompleted = AdvertisementName == data.advertisementName ?? "";
        print(data.advertisementName)
        return scanCompleted;
    }
    
    /// スキャン中に定期的にスキャンを停止するかどうかを尋ねる通知
    /// - Parameters:
    /// - Returns: true:停止する false:停止しない
    func doWantToStopScanning() -> Bool {
        if scanCompleted {
            print("scanCompleted!!")
        }
        return scanCompleted;
    }
    /// Bluetoothの電源が現在オンになった通知
    func bluetoothPoweredOn() { print("Central Service + bluetoothPoweredOn") }
   
    /// Bluetoothの電源が現在オフになった通知
    func bluetoothPoweredOff() { print("Central Service + bluetoothPoweredOff") }
    
    /// BluetoothLowEnergyの使用が許可されていない通知
    func bluetoothUnauthorized() { print("Central Service + bluetoothUnauthorized") }

}

