//
//  CentralServiceError.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/28.
//

import Foundation

/// CentralServiceのエラー
public enum CentralServiceError: Error {
    /// 既にスキャンが実行されている
    case AlreadyScanning
    
    /// 既に接続されている
    case AlreadyConnected
}
