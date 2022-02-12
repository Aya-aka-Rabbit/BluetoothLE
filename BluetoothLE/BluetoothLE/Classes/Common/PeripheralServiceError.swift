//
//  PeripheralServiceError.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/01/23.
//

import Foundation

/// PeripheralServiceのエラー情報
public enum PeripheralServiceError: Error {
    /// アドバタイズサービスUUIDが追加されていないため、アドバタイズを開始できない
    case AdvertisementServiceIdNotAdded
    
    /// 既にアドバタイズが実行されている
    case AlreadyAdvertised
    
    /// 接続後にサービスのフェッチがされていない
    case NotFetchedServices
    
    /// 接続後にサービス内データのフェッチがされていない
    case NotFetchCharacteristics
}
