//
//  KeychainManager.swift
//  AnyType
//
//  Created by Denis Batvinkin on 11/07/2019.
//  Copyright © 2019 AnyType. All rights reserved.
//

import Security
import Foundation

enum KeychainItemLabel: String {
    case PINCodeLabel = "CRYP.PINCodeItemLabel"
    case JWTAccessTokenLabel = "CRYP.JWTAccessTokenLabel"
    case JWTRefreshTokenLabel = "CRYP.JWTRefreshToken"
    case FireBaseTokenLabel = "CRYP.FireBaseToken"
}

/// Wrapper for keychain store
class KeychainService {
	private let secureStoreQueryable: SecureStoreQueryable
	
	
    // MARK: - Lifecycle
    
    init(secureStoreQueryable: SecureStoreQueryable) {
		self.secureStoreQueryable = secureStoreQueryable
    }
	
    // MARK: - Public methods
    
    /// Add item (password, key, certificate, etc.) to keychain
    ///
    /// - Parameters:
    ///   - item: Item to store in keychain
    func storeItem(item: String) throws {
		guard let dataItem = item.data(using: .utf8) else {
			throw KeychainError.stringItem2DataConversionError
		}
        
        // try to update item in keychain
        let attributes: [String: Any] = [
            (kSecValueData as String): dataItem
		]
        var query = self.secureStoreQueryable.query

        var status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        // If item wasn't found in keychain, than try to add it to keychain
        if status != errSecSuccess {
			query[String(kSecValueData)] = dataItem
            status = SecItemAdd(query as CFDictionary, nil)
        }
		
		if status != errSecSuccess {
			throw KeychainError.keychainError(status: status)
		}
    }
    
	/// Obtain item from keychain
	///
	/// - Returns: Stored item from keychain
    func retreiveItem() throws -> String? {
        var query = self.secureStoreQueryable.query
		query[String(kSecMatchLimit)] = kSecMatchLimitOne
		query[String(kSecReturnAttributes)] = kCFBooleanTrue
		query[String(kSecReturnData)] = kCFBooleanTrue
		
        var item: CFTypeRef?
        
        // try to find item in keychain
        let status = SecItemCopyMatching(query as CFDictionary, &item)
		var currentToken: String?
		
		if status == errSecSuccess {
			guard
				let existingItem = item as? [String: Any],
				let savedItemData = existingItem[kSecValueData as String] as? Data,
				let itemToken = String(data: savedItemData, encoding: .utf8)
				else {
					throw KeychainError.data2StringItemConversionError
			}
			currentToken = itemToken
		} else {
			throw KeychainError.keychainError(status: status)
		}
		return currentToken
    }
    
    /// Remove item from keychain
    func removeItem() throws {
        let query = self.secureStoreQueryable.query
        
        let status = SecItemDelete(query as CFDictionary)
		
		guard status == errSecSuccess || status == errSecItemNotFound else {
			throw KeychainError.keychainError(status: status)
		}
    }
	
}