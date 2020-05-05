//
//  BlockModel+NewModels+Information+Details.swift
//  AnyType
//
//  Created by Dmitry Lobanov on 29.04.2020.
//  Copyright © 2020 AnyType. All rights reserved.
//

import Foundation
import os

private extension Logging.Categories {
    static let pageDetails: Self = "BlockModels.Block.Information.PageDetails"
}

// MARK: Details
extension BlockModels.Block.Information {
    struct PageDetails {
        // MARK: Properties
        /// By default, we use `Details.id()` as a `Key` in this dictionary.
        /// But it is possible to use other id.
        ///
        var details: [String : Details]

        // MARK: Convenient Accessors
        var title: Details.Title? {
            if case let .title(title) = details[Details.Title.id] {
                return title
            }
            return nil
        }

        // MARK: - ToList
        func toList() -> [Details] {
            Array(details.values)
        }

        // MARK: - Initialization
        
        /// Designed initializer.
        /// - Parameter details: A dictionary of details.
        init(_ details: [String : Details]) {
            self.details = details
        }
        
        // MARK: - Initialization / Convenience
        
        /// Create details from a list. It is required for parsing.
        /// - Parameter list: A list of details that we are converting to a `dictionary` and using `.id()` function as a `key`.
        init(_ list: [Details]) {
            let keys = list.compactMap({($0.id(), $0)})
            self.details = .init(keys, uniquingKeysWith: { (lhs, rhs) -> BlockModels.Block.Information.Details in
                return rhs
            })
        }
        
        /// Create empty page details.
        /// It is not designed to be public.
        /// Use our static variable instead.
        ///
        private init() {
            self.init([:])
        }
        
        static var empty: PageDetails = .init()
    }

    enum Details {
        case title(Title)
        case icon
        
        /// This function returns an id for a `case`.
        /// This key we use for middleware details keys and also we use it to store our details in `[String : Details]` above in PageDetails.
        /// But it is still a key.
        ///
        /// - Returns: A key.
        func id() -> String {
            switch self {
            case .title: return Title.id
            default:
                let logger = Logging.createLogger(category: .pageDetails)
                os_log(.debug, log: logger, "Don't forget to implement other details.")
                return ""
            }
        }
        
        /// This is "likeness" `id` that `erases associated value` of enum.
        /// We need it as id in dictionaries.
        ///
        func kind() -> Kind {
            switch self {
            case .title: return .title
            case .icon: return .icon
            }
        }
    }
}

// MARK: DetailsMatching
// TODO: Rethink later. It should be done via Keys.
extension BlockModels.Block.Information.Details {
    /// Actually, we could done this in the same way as EnvironemntKey and EnvironmentValues.
    enum Kind {
        case title
        case icon
    }
}

// MARK: Protocols
private protocol DetailsEntryIdentifiable {
    associatedtype ID
    static var id: ID {get}
}

// MARK: Details / Title
extension BlockModels.Block.Information.Details {
    /// It is a custom detail.
    /// This detail refers to a `Title` that is coming in middleware `details`.
    /// Its id has value "name".
    /// But, it is doc, so, make sure that you use correct id if something goes wrong.
    ///
    struct Title {
        private(set) var text: String = ""
        private(set) var id: String = Self.id
        mutating func update(text: String) {
            self.text = text
        }
        func updated(text: String) -> Self {
            .init(text: text)
        }
        init(text: String) {
            self.text = text
        }
    }
}

// MARK: Details / Title / Key
extension BlockModels.Block.Information.Details.Title: DetailsEntryIdentifiable {
    static var id: String = "name"
}
