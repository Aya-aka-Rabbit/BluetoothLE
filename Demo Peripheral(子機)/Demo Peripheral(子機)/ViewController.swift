//
//  ViewController.swift
//  Demo Peripheral(子機)
//
//  Created by r.nishizaki on 2022/01/22.
//

import UIKit
import BluetoothLE

class ViewController: UIViewController {

    @IBOutlet weak var text1: UILabel!
    var service : PeripheralService? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = ServiceManager.sharedPeripheral()
        service?.delegate = self
    }
    
    /// アドバタイズを開始して、セントラル(親機)に存在を知らせる
    /// - Parameter sender: ボタン
    @IBAction func onAdvertiseStart(_ sender: Any) {
        let uuid = UUID().uuidString
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
        _ = try? service?.stop()
    }
}

extension ViewController : PeripheralServiceDelegate  {
    
    func advertisementLocalName() -> String {
        "Sample_Peripheral"
    }

    /// Bluetoothの電源が現在オンになった通知
    func bluetoothPoweredOn() { print("bluetoothPoweredOn") }
   
    /// Bluetoothの電源が現在オフになった通知
    func bluetoothPoweredOff() { print("bluetoothPoweredOff") }
    
    /// BluetoothLowEnergyの使用が許可されていない通知
    func bluetoothUnauthorized() { print("bluetoothUnauthorized") }

}


