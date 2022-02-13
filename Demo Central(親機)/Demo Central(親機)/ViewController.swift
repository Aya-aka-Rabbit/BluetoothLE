//
//  ViewController.swift
//  Demo Central(親機)
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
    
    /// 親機(セントラル)のサービスオブジェクト
    var service : CentralService? = nil

    /// 接続リストのテーブル
    @IBOutlet weak var tableView: UITableView!
    
    /// 接続リスト
    ///  key 子機(ペリフェラル)のID
    var connectionList : [String: ConnectedPeripheral] = [:]
    
    /// 接続している子機(ペリフェラル)のIDリスト
    var peripheralIdList : [String] = []

    /// 画面ロード完了時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = ServiceManager.sharedCentral()
        service?.delegate = self
        
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.borderWidth = 2.0
    }
    
    /// 画面表示前の処理
    override func viewWillAppear(_ animated: Bool) {
        
        var removeIdList : [String] = []
        
        connectionList.forEach { item in
            if item.value.state == .disconnecting || item.value.state == .disconnected {
                removeIdList.append(item.key)
            }
        }
        
        removeIdList.forEach { key in
            connectionList.removeValue(forKey: key)
            peripheralIdList.removeAll(where: { item in
                return item.caseInsensitiveCompare(key) == .orderedSame
            })
        }
        
        tableView.reloadData()
    }
    
    /// スキャンを開始して、子機(ペリフェラル)を探す
    /// - Parameter sender: ボタン
    @IBAction func onScanStart(_ sender: Any) {
        _ = service?.stop()
        do {
            _ = try service?.startWithServiceId(id: "1645070b-d162-1b08-dde0-69d7a4bdfc26")
        }
        catch let error {
            print(error)
        }
    }
    
    /// スキャンを停止
    /// - Parameter sender: ボタン
    @IBAction func onAdvertiseStop(_ sender: Any) {
        _ = service?.stop()
    }

    /// 画面遷移制御
    /// - Parameters:
    ///   - segue: segue
    ///   - sender: ViewContorller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let nextView = segue.destination as! DetailViewController
            guard tableView.indexPathForSelectedRow != nil else { return }
            
            let index = tableView.indexPathForSelectedRow!.row
            let key = peripheralIdList[index]
            nextView.peripheralInfo = connectionList[key]
            
            // 選択解除
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        }
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "接続ずみの子機(ペリフェラル)ID一覧"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralIdList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = peripheralIdList[indexPath.row]
        return cell
    }
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: nil)
    }
}

extension ViewController : CentralServiceDelegate  {
    
    /// 親機(セントラル)がスキャン中に子機(ペリフェラル)を検出した際の通知
    /// - Parameters:
    ///   - data: 子機(ペリフェラル)の情報
    ///   - connectable: 子機(ペリフェラル)が接続可能であるかどうか
    func didDiscoveredPeripheral(information data:DiscoveryPeripheralData, isConnectable connectable:Bool) {
        
        // 既に接続済みか？
        guard let key = data.peripheralId else { return }
        if connectionList.keys.contains(where: { $0 == key }) { return }
        
        let alert: UIAlertController = UIAlertController(title: "接続確認",
                                                         message: "接続しますか？",
                                                         preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "接続",
                                                         style: UIAlertAction.Style.default,
                                                         handler: { _ in
            guard let instance = try? self.service?.connect(information: data) else { return }
            self.connectionList[key] = instance
            self.peripheralIdList.append(key)
            _ = self.service?.stop()
            
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル",
                                                        style: UIAlertAction.Style.cancel,
                                                        handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// 親機(セントラル)が子機(ペリフェラル)に接続した際の通知
    /// - Parameters:
    ///   - peripheralId: 接続した子機(ペリフェラル)のID
    ///   - error: 失敗した際のエラー情報
    func didPeripheralConnect(peripheralId:String, error: Error?) {
        tableView.reloadData()
    }
}

