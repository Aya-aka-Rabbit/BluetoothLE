//
//  ResponseCode.swift
//  BluetoothLE
//
//  Created by r.nishizaki on 2022/02/05.
//

import Foundation
import CoreBluetooth

/// 要求に対する応答コード
public enum ResponseCode
{
    // 要求が正常に完了
    case success
    
    // 属性ハンドルが無効
    case invalidHandle
    
    // 権限により、属性の値の読み取りが禁止されている
    case readNotPermitted
    
    // 権限により、属性の値を書き込むことが禁止されている
    case writeNotPermitted
    
    // ProtocolData Unit（PDU）が無効
    case invalidPdu
    
    // 認証がないため、属性の値の読み取りまたは書き込みに失敗
    case insufficientAuthentication
    
    // クライアントから受信した要求をサポートしていない
    case requestNotSupported
    
    // 指定されたオフセット値は、属性の値の終わりを超えた
    case invalidOffset
    
    // 許可がないため、属性の値の読み取りまたは書き込みに失敗
    case insufficientAuthorization
    
    // キュー内の書き込み要求が多すぎるため失敗
    case prepareQueueFull
    
    // 指定された属性ハンドル範囲内に属性が見つからない
    case attributeNotFound
    
    // ATT読み取りBLOB要求は、属性の読み取りまたは書き込みを行うことができない
    case attributeNotLong
    
    // このリンクの暗号化に使用される暗号化キーのサイズが不十分
    case insufficientEncryptionKeySize
    
    // 属性の値の長さは、意図した操作に対して無効
    case invalidAttributeValueLength
    
    // ATT要求で発生する可能性の低いエラーが発生
    case unlikelyError
    
    // 暗号化が行われていないため、属性の値の読み取りまたは書き込みに失敗
    case insufficientEncryption
    
    // 属性タイプは、上位層の仕様で定義されているサポートされているグループ化属性ではない
    case unsupportedGroupType
    
    // ATT要求を完了するにはリソースが不十分
    case insufficientResources
    
    /// 応答コードを CBATTError のエラーコードに変換する
    /// - Parameter code: 応答コード
    /// - Returns: エラーコード
    func toErrorCode() -> CBATTError.Code
    {
        switch self {
            // 要求が正常に完了
            case .success:
                return CBATTError.success
                
            // 属性ハンドルが無効
            case .invalidHandle:
                return CBATTError.invalidHandle
            
            // 権限により、属性の値の読み取りが禁止されている
            case .readNotPermitted:
                return CBATTError.invalidHandle
        
            // 権限により、属性の値を書き込むことが禁止されている
            case .writeNotPermitted:
                return CBATTError.invalidHandle
        
            // ProtocolData Unit（PDU）が無効
            case .invalidPdu:
                return CBATTError.invalidPdu
        
            // 認証がないため、属性の値の読み取りまたは書き込みに失敗
            case .insufficientAuthentication:
                return CBATTError.insufficientAuthentication
        
            // クライアントから受信した要求をサポートしていない
            case .requestNotSupported:
                return CBATTError.requestNotSupported
        
            // 指定されたオフセット値は、属性の値の終わりを超えた
            case .invalidOffset:
                return CBATTError.invalidOffset
        
            // 許可がないため、属性の値の読み取りまたは書き込みに失敗
            case .insufficientAuthorization:
                return CBATTError.insufficientAuthorization
        
            // キュー内の書き込み要求が多すぎるため失敗
            case .prepareQueueFull:
                return CBATTError.prepareQueueFull
        
            // 指定された属性ハンドル範囲内に属性が見つからない
            case .attributeNotFound:
                return CBATTError.attributeNotFound
        
            // ATT読み取りBLOB要求は、属性の読み取りまたは書き込みを行うことができない
            case .attributeNotLong:
                return CBATTError.attributeNotLong
        
            // このリンクの暗号化に使用される暗号化キーのサイズが不十分
            case .insufficientEncryptionKeySize:
                return CBATTError.insufficientEncryptionKeySize
        
            // 属性の値の長さは、意図した操作に対して無効
            case .invalidAttributeValueLength:
                return CBATTError.invalidAttributeValueLength
        
            // ATT要求で発生する可能性の低いエラーが発生
            case .unlikelyError:
                return CBATTError.unlikelyError
        
            // 暗号化が行われていないため、属性の値の読み取りまたは書き込みに失敗
            case .insufficientEncryption:
                return CBATTError.insufficientEncryption
        
            // 属性タイプは、上位層の仕様で定義されているサポートされているグループ化属性ではない
            case .unsupportedGroupType:
                return CBATTError.unsupportedGroupType
        
            // ATT要求を完了するにはリソースが不十分
            case .insufficientResources:
                return CBATTError.insufficientResources
        }
    }
}
