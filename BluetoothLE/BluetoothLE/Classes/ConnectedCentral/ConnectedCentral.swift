//
//  ConnectedCentral.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/02/05.
//

import Foundation
import CoreBluetooth

/// 子機(ペリフェラル)と接続済みの親機(セントラル)サービスクラス
public class ConnectedCentral : NSObject {
    
    /// 接続している親機(セントラル)のインスタンス
    private (set) var central : CBCentral
        
    /// コンストラクタ
    /// - Parameter central: 接続済みの親機(セントラル)
    init(central: CBCentral) {
        self.central = central
        super.init()
    }
}

// MARK: - 外部公開

/// 子機(ペリフェラル)と接続済みの親機(セントラル)サービスクラス
extension ConnectedCentral {
    
    /// 親機(セントラル)のID
    public var centralId : String {
        get {
            central.identifier.uuidString
        }
    }
}
