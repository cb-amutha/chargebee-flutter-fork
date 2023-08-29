//
//  FlutterErrorHandler.swift
//  chargebee_flutter_sdk
//
//  Created by Amutha C on 20/04/22.
//

import Foundation
#if canImport(FlutterMacOS)
import FlutterMacOS
#else
import Flutter
import Chargebee
#endif

extension FlutterError {
    
    static func noArgsError() -> FlutterError{
        return FlutterError(code: "400",
                            message: "Could not find query params",
                            details: "Make sure you pass Map as query params")
    }

    static func chargebeeError(_ error: CBError) -> FlutterError {
        return FlutterError(code: "\(errorCode(error: error).rawValue)",
                            message: error.errorDescription,
                            details: error.userInfo)
    }
    
    static func purchaseError(_ error: CBPurchaseError) -> FlutterError {
        return FlutterError (code: "\(CBNativeError.errorCode(purchaseError: error).rawValue)",
                             message: error.errorDescription,
                             details: error.userInfo)
    }

    static func productIdentifierError(_ error: Error) -> FlutterError {
        if let error = error as? CBPurchaseError {
            return FlutterError (code: "\(CBNativeError.invalidCatalogVersion.rawValue)",
                                 message: error.errorDescription,
                                 details: error.userInfo)
        } else {
            return chargebeeError(error as! CBError)
        }
    }

    static func jsonSerializationError(_ errorDescription: String) -> FlutterError {
        return FlutterError(code: "\(CBNativeError.systemError.rawValue)",
                            message: errorDescription,
                            details: ["message": "\(errorDescription)"])
    }
    
    static func restoreError(_ error: RestoreError) -> FlutterError {
        let restoreError = error.asNSError
        return FlutterError(code: "\(restoreError.code)",
                             message: error.errorDescription,
                            details: restoreError.userInfo)
    }
    
    internal static func errorCode(error: CBError) -> CBNativeError {
        switch error.httpStatusCode {
        case 401:
            return CBNativeError.invalidAPIKey
        case 404:
            return CBNativeError.invalidSdkConfiguration
        default:
            return CBNativeError.unknown
        }
    }

}

extension CBPurchaseError {
    public var skErrorCode: Int {
        switch self {
        case .unknown: return 0
        case .invalidClient: return 1
        case .userCancelled: return 2
        case .paymentFailed: return 3
        case .paymentNotAllowed: return 4
        case .productNotAvailable: return 5
        case .cannotMakePayments: return 6
        case .networkConnectionFailed: return 7            
        case .productsNotFound: return 8
        case .privacyAcknowledgementRequired: return 9
        case .invalidOffer: return 11
        case .invalidPromoCode: return 12
        case .invalidPrice: return 14
        case .invalidPromoOffer: return 13
        case .invalidSandbox: return 8
        case .productIDNotFound: return 10
        case .skRequestFailed:return 15
        case .noProductToRestore:return 16
        case .invalidSDKKey:return 17
        case .invalidCustomerId:return 18
        case .invalidCatalogVersion:return 19
        case .invalidPurchase:return 20
        }
    }
}

enum CBNativeError: Int, Error {
    case unknown = 0
    
    // MARK: Chargebee Errors
    case invalidAPIKey = 999
    case invalidSdkConfiguration = 1000
    case invalidCatalogVersion = 1001
    case cannotMakePayments = 1002
    case noProductToRestore = 1003
    case invalidResource = 1004
    
    // MARK: Store Errors
    case invalidOffer = 2001
    case invalidPurchase = 2002
    case invalidSandbox = 2003
    case networkError = 2004
    case paymentFailed = 2005
    case paymentNotAllowed = 2006
    case productNotAvailable = 2007
    case purchaseNotAllowed = 2008
    case purchaseCancelled = 2009
    case storeProblem = 2010
    case invalidReceipt = 2011
    case requestFailed = 2012
    case productPurchasedAlready = 2013
    
    // MARK: Restore Error
    case noReceipt = 2014
    case refreshReceiptFailed = 2015
    case restoreFailed = 2016
    case invalidReceiptURL = 2017
    case invalidReceiptData = 2018
    case noProductsToRestore = 2019
    case serviceError = 2020
    
    // MARK: General Errors
    case systemError = 3000

}

extension CBNativeError {
    static func errorCode(purchaseError: CBPurchaseError) -> CBNativeError {
        switch purchaseError {
        case .productIDNotFound, .productsNotFound, .productNotAvailable:
            return CBNativeError.productNotAvailable
        case .skRequestFailed:
            return CBNativeError.requestFailed
        case .cannotMakePayments:
            return CBNativeError.cannotMakePayments
        case .noProductToRestore:
            return CBNativeError.noProductToRestore
        case .invalidSDKKey:
            return CBNativeError.invalidSdkConfiguration
        case .invalidCustomerId:
            return CBNativeError.invalidSdkConfiguration
        case .invalidCatalogVersion:
            return CBNativeError.invalidCatalogVersion
        case .userCancelled:
            return CBNativeError.purchaseCancelled
        case .paymentFailed:
            return CBNativeError.paymentFailed
        case .invalidPurchase:
            return CBNativeError.invalidPurchase
        case .invalidClient, .privacyAcknowledgementRequired:
            return CBNativeError.purchaseNotAllowed
        case .networkConnectionFailed:
            return CBNativeError.networkError
        case .unknown:
            return CBNativeError.unknown
        case .paymentNotAllowed:
            return CBNativeError.paymentNotAllowed
        case .invalidOffer, .invalidPrice, .invalidPromoCode, .invalidPromoOffer:
            return CBNativeError.invalidOffer
        case .invalidSandbox:
            return CBNativeError.invalidSandbox
        }
    }
}