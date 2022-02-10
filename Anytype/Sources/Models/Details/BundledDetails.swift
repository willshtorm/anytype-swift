//
//  ObjectDetailsItem.swift
//  Anytype
//
//  Created by Konstantin Mordan on 22.11.2021.
//  Copyright © 2021 Anytype. All rights reserved.
//

import Foundation
import AnytypeCore
import BlocksModels
import ProtobufMessages
import SwiftProtobuf

enum BundledDetails {
    case name(String)
    case iconEmoji(String)
    case iconImageHash(Hash?)
    case coverId(String)
    case coverType(CoverType)
    case type(ObjectTemplateType)
    case isDraft(Bool)
}

extension BundledDetails {
    
    var key: String {
        switch self {
        case .name: return BundledRelationKey.name.rawValue
        case .iconEmoji: return BundledRelationKey.iconEmoji.rawValue
        case .iconImageHash: return BundledRelationKey.iconImage.rawValue
        case .coverId: return BundledRelationKey.coverId.rawValue
        case .coverType: return BundledRelationKey.coverType.rawValue
        case .type: return BundledRelationKey.type.rawValue
        case .isDraft: return BundledRelationKey.isDraft.rawValue
        }
    }
    
    var value: Google_Protobuf_Value {
        switch self {
        case .name(let string): return string.protobufValue
        case .iconEmoji(let string): return string.protobufValue
        case .iconImageHash(let hash): return (hash?.value ?? "").protobufValue
        case .coverId(let string): return string.protobufValue
        case .coverType(let coverType): return coverType.rawValue.protobufValue
        case .type(let objectTemplateType): return objectTemplateType.rawValue.protobufValue
        case .isDraft(let bool): return bool.protobufValue
        }
    }
    
}