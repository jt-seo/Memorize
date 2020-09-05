//
//  EmojiGameExtension.swift
//  Memorize
//
//  Created by JT3 on 2020/09/04.
//  Copyright © 2020 JT2. All rights reserved.
//

import Foundation

struct WrapperOfNSCoding<Wrapped>: Codable where Wrapped: NSCoding {
    var wrapped: Wrapped

    init(_ wrapped: Wrapped) { self.wrapped = wrapped }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let object = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [Wrapped.self], from: data) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "failed to unarchive an object")
        }
        guard let wrapped = object as? Wrapped else {
            throw DecodingError.typeMismatch(Wrapped.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "unarchived object type was \(type(of: object))"))
        }
        self.wrapped = wrapped
    }

    func encode(to encoder: Encoder) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: wrapped, requiringSecureCoding: false)
        var container = encoder.singleValueContainer()
        try container.encode(data)
    }
}
